$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smithy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smithycms"
  s.version     = Smithy::VERSION
  s.authors     = ["Tim Glen"]
  s.email       = ["tim@tag.ca"]
  s.homepage    = "http://tag.ca/"
  s.summary     = "A good CMS written in Rails."
  s.description = "Smithy CMS is a Rails Engine built to manage your content easily and play nicely with other parts of your app."

  s.required_ruby_version = '>= 1.9.3'

  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options = ["--main"]
  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 4.0.0', '< 5'
  s.add_dependency 'jquery-rails'

  s.add_dependency 'autoprefixer-rails' # for bootstrap-sass
  s.add_dependency 'awesome_nested_set', '~> 3.0.1'
  s.add_dependency 'bootstrap-sass', '~> 3.2.0'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'font-awesome-sass', '~> 4.2'
  s.add_dependency 'fog', '~> 1.36'
  s.add_dependency 'formtastic', '~> 3.1.3'
  s.add_dependency 'formtastic-bootstrap', '~> 3.1.1'
  s.add_dependency 'friendly_id', '~> 5.0.4'
  s.add_dependency 'httparty', '~> 0.13.1'
  s.add_dependency 'json', '~> 1.8.1'
  s.add_dependency 'kaminari', '~> 0.16.1'
  s.add_dependency 'liquid', '~> 2.6.1'
  s.add_dependency 'refile'
  s.add_dependency 'refile-mini_magick'
  s.add_dependency 'refile-s3'
  s.add_dependency 'remotipart', '~> 1.2'
  s.add_dependency 'sass-rails'
  s.add_dependency 'slodown', '0.1.3'
  s.add_dependency 'rack-cache'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-livereload'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'letter_opener'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rack-livereload'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'smithycms-auth'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'terminal-notifier-guard'
end
