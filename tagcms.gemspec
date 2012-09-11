$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tagcms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tagcms"
  s.version     = Tagcms::VERSION
  s.authors     = ["Tim Glen"]
  s.email       = ["tim@tag.ca"]
  s.homepage    = "http://tag.ca/"
  s.summary     = "A good CMS written in Rails."
  s.description = "Better than the rest.jj"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec-rails"
end
