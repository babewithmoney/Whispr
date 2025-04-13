#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Compile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Set up database
bundle exec rails db:migrate
bundle exec rails db:seed 