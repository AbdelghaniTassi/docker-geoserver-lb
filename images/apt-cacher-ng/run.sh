#!/bin/bash
echo "Stopping..."
docker stop apt-cacher-ng || true && docker rm apt-cacher-ng || true
echo "Starting..."
docker run -d -p 3142:3142 --name apt-cacher-ng apt-cacher-ng
echo -n "IP:"; docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apt-cacher-ng
