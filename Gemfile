source "http://rubygems.org"

# Declare your gem's dependencies in smithy.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '~> 1.2.4'
end

gem 'slodown', :git => 'https://github.com/sterrym/slodown.git'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'debugger'
  gem 'fuubar'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'letter_opener'
  gem 'rack-livereload'
  gem 'rspec-rails', '~> 2.14'
  gem 'ruby_gntp', '~> 0.3.4'
  gem 'quiet_assets', '~> 1.0.2'
end

group :test do
  gem 'capybara', '~> 2.0.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'ffaker'
  gem 'fakeweb'
  gem 'launchy'
  gem 'rb-fsevent'
  gem 'shoulda-matchers'
  gem 'spork', '~> 1.0rc'
  gem 'sqlite3'
end
