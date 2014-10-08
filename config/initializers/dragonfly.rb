require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  verify_urls true
  secret "7fb765cbc9f1d92d5d1a56a43193d34d4f9b54dced3e62cb4e42f25d2500dd0f"

  convert_command  = `which convert`.strip.presence || "/usr/local/bin/convert"
  identify_command = `which identify`.strip.presence || "/usr/local/bin/identify"

  url_format '/uploads/assets/:job/:name'

  datastore Smithy::Asset.dragonfly_datastore
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
