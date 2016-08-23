require 'rspec/rails'
require 'byebug'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl_rails'
require 'fakeweb'
require 'ffaker'
require 'fuubar'
require 'launchy'
require 'letter_opener'
require 'rack-livereload'
require 'shoulda-matchers'
require 'smithycms-auth'

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

RSpec.configure do |config|
  # include the routes url_helpers
  config.before(:suite) do
    FactoryGirl.reload
  end
  config.before do
    @routes = Smithy::Engine.routes
    # for rspec >= 2.13
    assertion_instance.instance_variable_set(:@routes, Smithy::Engine.routes) if respond_to?(:assertion_instance)
  end
  config.infer_spec_type_from_file_location!
  # configure Database cleaning
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do |group|
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:type] == :feature ? :truncation : :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
