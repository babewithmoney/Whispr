# config/initializers/database_connection.rb
# Force ActiveRecord to establish connection via TCP
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Set PostgreSQL environment variables to force TCP
    ENV['PGSSLMODE'] = 'require'
    
    # Get the configuration from database.yml
    config = Rails.application.config.database_configuration[Rails.env].merge(
      host: ENV.fetch('DATABASE_HOST', 'localhost'),
      port: ENV.fetch('DATABASE_PORT', 5432),
      adapter: 'postgresql'
    )
    
    # Establish the connection
    ActiveRecord::Base.establish_connection(config)
    
    # We'll let SolidQueue and SolidCache handle their own connections through database.yml
    Rails.logger.info "Database connection established using TCP with host: #{config[:host]} and port: #{config[:port]}"
  end
end
