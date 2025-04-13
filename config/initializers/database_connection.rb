# config/initializers/database_connection.rb
# Force ActiveRecord to establish connection via TCP
Rails.application.config.after_initialize do
  if Rails.env.production?
    ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "primary").configuration_hash.merge(
        host: ENV.fetch('DATABASE_HOST', 'localhost'),
        port: ENV.fetch('DATABASE_PORT', 5432),
        adapter: 'postgresql',
        sslmode: 'require'
      )
    )
    
    # Force queue connection too if it exists
    if defined?(SolidQueue)
      begin
        SolidQueue::Record.establish_connection(
          ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "queue").configuration_hash.merge(
            host: ENV.fetch('DATABASE_HOST', 'localhost'),
            port: ENV.fetch('DATABASE_PORT', 5432),
            adapter: 'postgresql',
            sslmode: 'require'
          )
        )
      rescue => e
        Rails.logger.error("Failed to establish queue connection: #{e.message}")
      end
    end
    
    # Force cache connection too if it exists
    if defined?(SolidCache)
      begin
        SolidCache::Record.establish_connection(
          ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "cache").configuration_hash.merge(
            host: ENV.fetch('DATABASE_HOST', 'localhost'),
            port: ENV.fetch('DATABASE_PORT', 5432),
            adapter: 'postgresql',
            sslmode: 'require'
          )
        )
      rescue => e
        Rails.logger.error("Failed to establish cache connection: #{e.message}")
      end
    end
  end
end
