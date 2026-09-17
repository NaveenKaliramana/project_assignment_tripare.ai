#!/bin/bash

BACKUP_FILE=$1

docker exec -i hotel_db psql \
-U admin \
-d postgres \
-c "DROP DATABASE IF EXISTS hotel_booking;"

docker exec -i hotel_db psql \
-U admin \
-d postgres \
-c "CREATE DATABASE hotel_booking;"

docker cp $BACKUP_FILE hotel_db:/tmp/restore.dump

docker exec hotel_db pg_restore \
-U admin \
-d hotel_booking \
-c \
/tmp/restore.dump

echo "Restore completed"