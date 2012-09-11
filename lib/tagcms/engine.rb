module Tagcms
  class Engine < ::Rails::Engine
    isolate_namespace Tagcms
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.integration_tool :rspec
    end
  end
end
