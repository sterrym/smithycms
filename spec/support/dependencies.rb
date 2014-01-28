require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'debugger'
require 'factory_girl_rails'
require 'fakeweb'
require 'ffaker'
require 'fuubar'
require 'launchy'
require 'letter_opener'
require 'rack-livereload'
require 'rspec-rails'
require 'shoulda-matchers'
require 'smithycms-auth'

Fog.mock! # this mocks out all AWS calls - really nice

RSpec.configure do |config|
  # configure Database cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do |group|
    DatabaseCleaner.strategy = group.example.metadata[:type] == :feature ? :truncation : :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
