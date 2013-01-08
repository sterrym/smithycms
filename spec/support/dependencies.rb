require 'capybara/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'ffaker'
require 'fakeweb'
require 'shoulda-matchers'

Fog.mock! # this mocks out all AWS calls - really nice
