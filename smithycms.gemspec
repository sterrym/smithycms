
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
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 4.0.4'
  s.add_dependency 'jquery-rails'

  s.add_dependency 'awesome_nested_set', '~> 3.0.0rc'
  s.add_dependency 'bootstrap-sass', '~> 2.3.2.1'
  s.add_dependency 'dragonfly', '~> 1.0.2'
  s.add_dependency 'dragonfly-s3_data_store', '~> 1.0.3'
  s.add_dependency 'font-awesome-sass-rails', '~> 3.0.2'
  s.add_dependency 'fog', '~> 1.20.0'
  s.add_dependency 'formtastic', '~> 2.2'
  s.add_dependency 'formtastic-bootstrap', '~> 2.1'
  s.add_dependency 'friendly_id', '~> 5.0.3'
  s.add_dependency 'httparty', '~> 0.13.0'
  s.add_dependency 'jquery-fileupload-rails', '~> 0.4.1'
  s.add_dependency 'json', '~> 1.8.1'
  s.add_dependency 'kaminari', '~> 0.15.1'
  s.add_dependency 'liquid', '~> 2.6.1'
  s.add_dependency 'slodown'
  s.add_dependency 'rack-cache'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'capybara', '~> 2.2.1'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails', '~> 4.4.1'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'guard', '~> 2.5.1'
  s.add_development_dependency 'guard-livereload'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'letter_opener'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rack-livereload'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'smithycms-auth'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'terminal-notifier-guard'
  s.extra_rdoc_files = [ "README.md" ]
end
