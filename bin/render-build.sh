#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
echo "Installing dependencies..."
bundle install

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate

# Compile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Build completed successfully!" 