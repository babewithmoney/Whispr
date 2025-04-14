# config/initializers/database_connection.rb
if Rails.env.production?
  # Set PostgreSQL environment variables to force TCP
  ENV['PGSSLMODE'] = 'require'
  
  # Configure the database connection
  Rails.application.config.after_initialize do
    ActiveRecord::Base.connection_pool.disconnect!
    
    config = {
      adapter: 'postgresql',
      host: ENV.fetch('DATABASE_HOST', 'localhost'),
      port: ENV.fetch('DATABASE_PORT', 5432),
      database: ENV.fetch('DATABASE_NAME', 'whispr_production'),
      username: ENV.fetch('DATABASE_USERNAME', 'postgres'),
      password: ENV.fetch('DATABASE_PASSWORD', '')
    }
    
    ActiveRecord::Base.establish_connection(config)
    Rails.logger.info "Database connection established using TCP with host: #{config[:host]} and port: #{config[:port]}"
  end
end
