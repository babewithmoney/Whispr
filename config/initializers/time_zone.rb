# Set the default timezone for the application
Time.zone = 'UTC'

# Set PostgreSQL timezone to match Rails
ActiveRecord::Base.connection.execute("SET timezone TO 'UTC'") rescue nil

# Configure Active Record time zone (using the new API)
ActiveRecord.default_timezone = :utc 