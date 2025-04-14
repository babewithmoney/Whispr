#!/usr/bin/env bash
# exit on error
set -o errexit

# Export environment variables for database connection
export PGSSLMODE=require
export PGHOST=${DATABASE_HOST}
export PGPORT=${DATABASE_PORT}
export PGUSER=${DATABASE_USER}
export PGPASSWORD=${DATABASE_PASSWORD}
export PGDATABASE=${DATABASE_NAME}

# Install dependencies
echo "Installing dependencies..."
bundle install

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate

# Compile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

echo "Build completed successfully!" 