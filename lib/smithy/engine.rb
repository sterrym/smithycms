module Smithy
  class Engine < ::Rails::Engine
    isolate_namespace Smithy
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end
    config.after_initialize do
      # we need to require all our model files so that ContentBlocks
      # are registered with the engine
      Dir[File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'smithy', '*.rb')].each {|file| require file }
    end
  end
end
