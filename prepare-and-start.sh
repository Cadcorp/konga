#!/bin/bash
# Startup script for Konga by Cadcorp
echo "Checking database environment variables:"
[[ -z "$DB_ADAPTER" ]] && { echo "DB_ADAPTER is empty"; exit 1; }
[[ -z "$DB_DATABASE" ]] && { echo "DB_DATABASE is empty"; exit 1; }
[[ -z "$DB_HOST" ]] && { echo "DB_HOST is empty"; exit 1; }
[[ -z "$DB_PORT" ]] && { echo "DB_PORT is empty"; exit 1; }
[[ -z "$DB_USER" ]] && { echo "DB_USER is empty"; exit 1; }
echo "  DB_ADAPTER=$DB_ADAPTER"
echo "  DB_DATABASE=$DB_DATABASE"
echo "  DB_HOST=$DB_HOST"
echo "  DB_PORT=$DB_PORT"
echo "  DB_USER=$DB_USER"

#if [[ "$NODE_ENV" == "development" ]]; then
#    apt-get update
#    apt-get install -y -qq postgresql-client
#    echo "Checking database connection:"
#    psql "host=$DB_HOST port=$DB_PORT dbname=$DB_DATABASE user=$DB_USER password=$DB_PASSWORD sslmode=require" -c "SELECT version();"
#fi

node --version
npm --version

if [[ ! -f "$PWD/prepare.done" ]]; then
    echo "Starting Konga prepare in $PWD"
    node ./bin/konga.js prepare --adapter postgres
    if [[ $? -eq 0 ]]; then
        touch "$PWD/prepare.done"
    fi
fi

echo "Starting Konga in $PWD"
echo "  KONG_HOOK_TIMEOUT=$KONG_HOOK_TIMEOUT"
echo "  KONGA_SEED_KONG_NODE_DATA_SOURCE_FILE=$KONGA_SEED_KONG_NODE_DATA_SOURCE_FILE"
echo "  KONGA_SEED_USER_DATA_SOURCE_FILE=$KONGA_SEED_USER_DATA_SOURCE_FILE"
echo "  NODE_ENV=$NODE_ENV"
node --harmony app.js --prod
