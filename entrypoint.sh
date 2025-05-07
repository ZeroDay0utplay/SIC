#!/bin/bash
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  export $(cat .env | xargs)
# Load from .envexamp if .env does not exist
elif [ -f .envexamp ]; then
  export $(cat .envexamp | xargs)
fi

# Remove any existing server PID file
rm -f /app/tmp/pids/server.pid

# Precompile assets
bundle exec rails assets:precompile RAILS_ENV=production
#bundle exec rails assets:precompile

# Migrate the database
bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails db:seed
# Start the Rails server
exec "$@"

