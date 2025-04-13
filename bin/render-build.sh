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

# Compile assets (with error handling)
echo "Asset precompilation starting..."
bundle exec rails assets:precompile RAILS_ENV=production || {
  echo "Asset precompilation failed, retrying with alternative configuration"
  # Try running asset precompilation with a simpler configuration
  bundle exec rake assets:precompile RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1
}

# Clean assets (with error handling)
echo "Asset cleaning starting..."
bundle exec rails assets:clean RAILS_ENV=production || {
  echo "Asset cleaning failed, but proceeding with deployment"
}

# Set up database
echo "Running migrations..."
bundle exec rails db:migrate RAILS_ENV=production
echo "Running seeds (if applicable)..."
bundle exec rails db:seed RAILS_ENV=production || true

echo "Deployment preparation complete!" 