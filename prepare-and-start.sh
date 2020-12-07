#!/bin/bash
apt-get update
apt-get install -y -qq postgresql-client

echo "Connecting to database in $PWD"
PGCONNSTR="host=$DB_HOST port=$DB_PORT dbname=$DB_DATABASE user=$DB_USER password=$DB_PASSWORD sslmode=require"
psql "$PGCONNSTR" -c "SELECT version();"

pushd /home/site/wwwroot
echo "Starting Konga in $PWD"

if [ ! -f "$PWD/prepare.done" ]; then
    node ./bin/konga.js prepare --adapter postgres
    if [ $? -eq 0 ]; then
        touch "$PWD/prepare.done"
    fi
fi

node --harmony app.js
