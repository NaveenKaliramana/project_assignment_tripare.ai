#!/bin/bash

mkdir -p backups

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

docker exec hotel_db pg_dump \
-U admin \
-d hotel_booking \
-F c \
-f /tmp/backup.dump

docker cp hotel_db:/tmp/backup.dump \
./backups/backup_${TIMESTAMP}.dump

echo "Backup created:"
echo "./backups/backup_${TIMESTAMP}.dump"