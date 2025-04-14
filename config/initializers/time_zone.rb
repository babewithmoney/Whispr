# Set the default timezone for the application
Time.zone = 'UTC'

# Set PostgreSQL timezone to match Rails
ActiveRecord::Base.connection.execute("SET timezone TO 'UTC'")

# Ensure Active Record uses the same timezone as Rails
ActiveRecord::Base.default_timezone = :utc 