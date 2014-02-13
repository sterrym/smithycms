require 'rubygems'

require 'coveralls'
Coveralls.wear! if ENV['TRAVIS']

require 'spork'

# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

Spork.prefork do
  # simplecov
  # unless ENV['DRB']
  #   require 'simplecov'
  #   SimpleCov.start 'rails'
  # end
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../spec/dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Run any available migration
  ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = "random"
    # Filter specs to only run focus specs
    config.filter_run :focus => true
    # if none are focused, run everything
    config.run_all_when_everything_filtered = true
    # include the routes url_helpers
    config.before do
      @routes = Smithy::Engine.routes
      # for rspec >= 2.13
      assertion_instance.instance_variable_set(:@routes, Smithy::Engine.routes) if respond_to?(:assertion_instance)
    end
  end
end

Spork.each_run do
  # simplecov
  # if ENV['DRB']
  #   require 'simplecov'
  #   SimpleCov.start 'rails'
  # end
  FactoryGirl.reload
end
