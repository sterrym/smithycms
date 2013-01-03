require 'rubygems'
require 'spork'

# uncomment the following line to use spork with the debugger
require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../spec/dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.use_transactional_fixtures = true
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = "random"
    # Filter specs to only run focus specs
    config.filter_run :focus => true
    # if none are focused, run everything
    config.run_all_when_everything_filtered = true
    # include the routes url_helpers
    config.include Smithy::Engine.routes.url_helpers
    config.include Rails.application.routes.url_helpers
  end
end

Spork.each_run do
end
