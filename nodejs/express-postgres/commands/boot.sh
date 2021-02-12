#!/bin/sh

set -eu

echo "Create posts table if needed"
host="postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@postgres/$POSTGRES_DB"
until psql $host --command='\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

psql $host \
  --command "CREATE TABLE IF NOT EXISTS posts (id SERIAL, title varchar(80), text text);"

echo "Install, link and build integration"
(
  cd /integration
  script/setup
  script/build
)

echo "Npm link in app"
cd /app && npm link @appsignal/nodejs
cd /app && npm link @appsignal/express

echo "Install dependencies"
cd /app && npm install

echo "Run express server"
cd /app && npx nodemon -e js,pug app.js
