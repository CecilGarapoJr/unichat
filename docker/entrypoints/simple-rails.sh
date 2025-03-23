#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
while ! pg_isready -h postgres -p 5432 -U postgres
do
  sleep 1
done

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
while ! redis-cli -h redis ping
do
  sleep 1
done

# Setup the database if it doesn't exist
echo "Setting up the database..."
bundle exec rails db:prepare

# Start the Rails server
echo "Starting Rails server..."
exec "$@"
