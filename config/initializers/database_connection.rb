# config/initializers/database_connection.rb
if Rails.env.production?
  # Set PostgreSQL environment variables to force TCP
  ENV['PGSSLMODE'] = 'require'
  
  # Configure the database connection
  Rails.application.config.after_initialize do
    config = {
      adapter: 'postgresql',
      host: ENV['DATABASE_HOST'],
      port: ENV['DATABASE_PORT'],
      database: ENV['DATABASE_NAME'],
      username: ENV['DATABASE_USER'],
      password: ENV['DATABASE_PASSWORD'],
      sslmode: 'require'
    }
    
    ActiveRecord::Base.establish_connection(config)
    Rails.logger.info "Database connection established using TCP with host: #{config[:host]} and port: #{config[:port]}"
  end
end
