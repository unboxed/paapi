#!/bin/bash

set -e

echo "Initializing PaAPI"
echo "Bundling gems"
bundle check || bundle install

if [ -f /app/tmp/pids/server.pid ]; then
  # Remove a potentially pre-existing server.pid for Rails.
  echo 'Remove pre-existing server.pid file'
  rm -f /app/tmp/pids/server.pid
fi

# parameters will pass to bundle exec from docker-compose
bundle exec "$@"
