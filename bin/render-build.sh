#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
echo "Installing dependencies..."
bundle install

# Set up database
echo "Setting up database..."
if [ -n "$DATABASE_URL" ]; then
  echo "Using DATABASE_URL for connection"
  export RAILS_DATABASE_URL="$DATABASE_URL"
fi

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate RAILS_ENV=production

# Compile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

echo "Build completed successfully!" 