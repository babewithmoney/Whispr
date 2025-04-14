#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
echo "Installing dependencies..."
bundle install

# Parse DATABASE_URL into individual components
if [ -n "$DATABASE_URL" ]; then
  echo "Parsing DATABASE_URL..."
  DB_PARTS=(${DATABASE_URL//[\/:@]/ })
  export DATABASE_USERNAME=${DB_PARTS[3]}
  export DATABASE_PASSWORD=${DB_PARTS[4]}
  export DATABASE_HOST=${DB_PARTS[5]}
  export DATABASE_PORT=${DB_PARTS[6]}
  export DATABASE_NAME=${DB_PARTS[7]}
fi

# Ensure we're in production mode for migrations
export RAILS_ENV=production

# Run database migrations with error handling
echo "Running database migrations..."
if ! bundle exec rails db:migrate; then
  echo "Migration failed. Attempting to create database..."
  bundle exec rails db:create
  bundle exec rails db:migrate
fi

# Compile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Build completed successfully!" 