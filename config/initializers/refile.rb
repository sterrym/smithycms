require "refile/rails"
require "refile/s3"

# Manually mount Refile before Smithy Engine
Refile.automount = false
Rails.application.routes.prepend do
  mount Refile.app, at: Refile.mount_point, as: :refile_app
end

# aws = {
#   access_key_id: 'AKIAJTMAZVFVSBOL6AKQ',
#   secret_access_key: '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',
#   region: 'us-west-2',
#   bucket: 'testsmithy',
# }

# Refile.cache = Refile::S3.new(prefix: "cache", **aws)
# Refile.store = Refile::S3.new(prefix: "store", **aws)

if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_S3_BUCKET'].present?
  aws = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_S3_REGION'],
    bucket: ENV['AWS_S3_BUCKET'],
  }
  Refile.cache = Refile::S3.new(prefix: "cache", **aws)
  Refile.store = Refile::S3.new(prefix: "store", **aws)
else
  Refile.store = Refile::Backend::FileSystem.new(Rails.root.join('public/smithy', Rails.env))
end