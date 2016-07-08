require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret ENV.fetch('DRAGONFLY_SECRET')

  url_format "/media/:job/:name"

  case Rails.env

  when :development?.to_proc
    datastore :file,
      :root_path => 'public/dragonfly',
      :server_root => 'public'

  when :test?.to_proc
    datastore :memory

  when :production?.to_proc
    datastore :s3,
      bucket_name: ENV.fetch('S3_FILE_UPLOADS_BUCKET'),
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_KEY_ID'),
      region: ENV.fetch('AWS_DEFAULT_REGION'),
      url_scheme: 'https'
  else
    raise "Dragonfly: don't know where to put files for this environment, #{Rails.env}"
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
