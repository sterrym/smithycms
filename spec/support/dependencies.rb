require 'factory_girl_rails'
require 'faker'
require 'fakeweb'
require 'shoulda-matchers'

Fog.mock! # this mocks out all AWS calls - really nice
