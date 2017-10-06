#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    catalog_watchdog.py - Reloads Geoserver catalog when changes are detected
"""

import os
import logging
import time
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
import requests
from threading import Timer

GS_URL_RELOAD = 'http://localhost:8080/geoserver/rest/reload'
GS_URL_RESET = 'http://localhost:8080/geoserver/rest/reset'
PATTERNS = ['*.xml']
GS_DATAFOLDER = os.environ['GEOSERVER_DATA_DIR']
GS_LOGLOCATION = os.environ['GEOSERVER_LOG_LOCATION']
GS_WATCH = int(os.getenv('GEOSERVER_CATALOG_WATCHDOG', 0)) == 1
GS_CREDENTIALS = os.getenv('GEOSERVER_CATALOG_WATCHDOG_CREDENTIALS', '')
#os.environ.pop('GEOSERVER_CATALOG_WATCHDOG_CREDENTIALS')


class Handler(PatternMatchingEventHandler):
    patterns = PATTERNS
    timer = None

    def on_modified(self, event):
        logging.info(event.src_path + ' modified')
        self.process(event)

    def on_created(self, event):
        logging.info(event.src_path + ' created')
        self.process(event)

    def on_deleted(self, event):
        logging.info(event.src_path + ' deleted')
        self.process(event)

    def on_moved(self, event):
        logging.info(event.src_path + ' moved')
        self.process(event)

    def process(self, event):
        """
        event.event_type
            'modified' | 'created' | 'moved' | 'deleted'
        event.is_directory
            True | False
        event.src_path
            path/to/observed/file
        """
        if self.timer:
            self.timer.cancel()

        # use timer to prevent spamming the api since geoserver might change alot of files simultaneously
        self.timer = Timer(2.0, self.reload_catalog)
        self.timer.start()

    def reload_catalog(self):
        self.timer = None
        u, p = GS_CREDENTIALS.split(':')

        # Reload configuration
        try:
            logging.info('Attempting to reload configuration at:{}'.format(GS_URL_RELOAD))
            req = requests.post(GS_URL_RELOAD, auth=(u, p))
            req.raise_for_status()
            if req.status_code >= 200 and req.status_code < 300:
                logging.info('Configuration reloaded')
        except requests.exceptions.RequestException as e:
            logging.exception('Configuration reload failed: ' + str(e))
        
        # Reset cache
        try:
            logging.info('Attempting to reset cache at:{}'.format(GS_URL_RESET))
            req = requests.post(GS_URL_RESET, auth=(u, p))
            req.raise_for_status()
            if req.status_code >= 200 and req.status_code < 300:
                logging.info('Cache reset')
        except requests.exceptions.RequestException as e:
            logging.exception('Cache reset failed: ' + str(e))


if __name__ == '__main__':
    if GS_WATCH:
        # init logging
        log_file_part1 = os.path.splitext(GS_LOGLOCATION)[0]
        log_file_part2 = os.path.splitext(os.path.basename(__file__))[0]
        log_file = '{}_{}.log'.format(log_file_part1, log_file_part2)
        logging.basicConfig(filename=log_file,
                            level=logging.INFO,
                            format='%(asctime)s - %(message)s',
                            datefmt='%Y-%m-%d %H:%M:%S')
        observer = Observer()
        observer.schedule(Handler(), path=GS_DATAFOLDER)
        observer.start()
        logging.info('Watching folder:{} for pattern:{}'.format(GS_DATAFOLDER, PATTERNS))

        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()

        observer.join()
