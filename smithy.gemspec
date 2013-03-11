$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smithy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smithy"
  s.version     = Smithy::VERSION
  s.authors     = ["Tim Glen"]
  s.email       = ["tim@tag.ca"]
  s.homepage    = "http://tag.ca/"
  s.summary     = "A good CMS written in Rails."
  s.description = "Better than the rest."

  # s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 3.2.11'
  s.add_dependency 'jquery-rails'

  s.add_dependency 'awesome_nested_set', '~> 2.1.5'
  s.add_dependency 'bootstrap-sass', '~> 2.3.0.0'
  s.add_dependency 'dragonfly', '~> 0.9.12'
  s.add_dependency 'font-awesome-sass-rails', '~> 2.0.0'
  s.add_dependency 'fog', '~> 1.7.0'
  s.add_dependency 'formtastic', '~> 2.2'
  s.add_dependency 'formtastic-bootstrap', '~> 2.0'
  s.add_dependency 'friendly_id', '~> 4.0.8'
  s.add_dependency 'httparty', '~> 0.8.3'
  s.add_dependency 'jquery-fileupload-rails', '~> 0.3.5'
  s.add_dependency 'json', '~> 1.7.7'
  s.add_dependency 'kaminari', '~> 0.13.0'
  s.add_dependency 'liquid', '~> 2.4.1'
  s.add_dependency 'slodown'
  s.add_dependency 'rack-cache'
  s.add_dependency 'sass-rails', '~> 3.1'

  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-livereload'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'letter_opener'
  s.add_development_dependency 'rack-livereload'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'ruby_gntp'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'quiet_assets'
end
