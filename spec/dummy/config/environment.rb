# Load the rails application
require File.expand_path('../application', __FILE__)

require 'binding_of_caller'
require 'better_errors'

# Initialize the rails application
Dummy::Application.initialize!
