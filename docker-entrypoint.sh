#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f tmp/pids/server.pid

# Wait for database to be ready
until pg_isready -h db -p 5432 -U postgres
do
  echo "Waiting for postgres to be ready..."
  sleep 2
done

# Run database migrations and setup
bundle exec rake db:migrate
bundle exec rake db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
