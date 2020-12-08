#!/bin/bash
apt-get update
apt-get install -y -qq postgresql-client

echo "Checking database environment variables:"
echo "  DB_ADAPTER=$DB_ADAPTER"
echo "  DB_DATABASE=$DB_DATABASE"
echo "  DB_HOST=$DB_HOST"
echo "  DB_PORT=$DB_PORT"
echo "  DB_USER=$DB_USER"
echo
echo "Checking database connection:"
psql "host=$DB_HOST port=$DB_PORT dbname=$DB_DATABASE user=$DB_USER password=$DB_PASSWORD sslmode=require" -c "SELECT version();"

if [ ! -f "$PWD/prepare.done" ]; then
    echo "Starting Konga prepare in $PWD"
    node ./bin/konga.js prepare --adapter postgres
    if [ $? -eq 0 ]; then
        touch "$PWD/prepare.done"
    fi
fi

echo "Starting Konga in $PWD"
node --harmony app.js
