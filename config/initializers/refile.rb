require "refile/rails"
require "refile/s3"

# Manually mount Refile before Smithy Engine
Refile.automount = false
Rails.application.routes.prepend do
  mount Refile.app, at: Refile.mount_point, as: :refile_app
end

# use a CDN/asset host if the main rails app is using one
if Rails.application.config.action_controller.asset_host.present?
  Refile.cdn_host = Rails.application.config.action_controller.asset_host
end

if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_S3_BUCKET'].present?
  aws = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION'] || 'us-east-1',
    bucket: ENV['AWS_S3_BUCKET'],
  }
  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
else
  Refile.store = Refile::Backend::FileSystem.new(Rails.root.join('public/smithy', Rails.env))
end
