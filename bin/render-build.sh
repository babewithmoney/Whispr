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
bundle install

# Compile assets
bundle install --gemfile=./Gemfile --path=vendor/bundle --jobs=4 --retry=3
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Set up database
bundle exec rails db:migrate
bundle exec rails db:seed || true 