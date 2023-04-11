#!/bin/bash

set -e

# Wait for the database to be ready
until nc -z -v -w30 $DATABASE_HOST 5432
do
  echo 'Waiting for PostgreSQL to start...'
  sleep 1
done

# Run database migrations
bundle exec rails db:migrate

# Seed the database
bundle exec rails db:seed

# Start the main process
exec "$@"
