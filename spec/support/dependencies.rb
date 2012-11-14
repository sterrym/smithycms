require 'capybara/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'faker'
require 'fakeweb'
require 'shoulda-matchers'

Fog.mock! # this mocks out all AWS calls - really nice

# set up focus ability and include all of our route url helpers
RSpec.configure do |config|
  # Filter specs to only run focus specs
  config.filter_run :focus => true
  # if none are focused, run everything
  config.run_all_when_everything_filtered = true

  config.include Smithy::Engine.routes.url_helpers
  config.include Rails.application.routes.url_helpers
end
