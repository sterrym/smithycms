module Smithy
  class Engine < ::Rails::Engine
    isolate_namespace Smithy
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end
    config.after_initialize do
    end
  end
end
