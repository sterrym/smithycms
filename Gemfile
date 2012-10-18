source "http://rubygems.org"

# Declare your gem's dependencies in tagcms.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '~> 1.2.4'
end

group :development, :test do
  gem 'debugger', '~> 1.2.1'
  gem 'fuubar'
  gem 'guard-rspec'
  gem 'rspec-rails', '~> 2.11'
end

group :test do
  gem 'capybara', '~> 1.1.2'
  gem 'factory_girl_rails', '~> 4.1.0'
  gem 'faker', '~> 1.1.2'
  gem 'shoulda-matchers', '~> 1.3.0'
  gem 'sqlite3'
end
