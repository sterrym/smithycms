module Smithy
  class Engine < ::Rails::Engine
    isolate_namespace Smithy

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', File.dirname(__FILE__)))
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)

    config.to_prepare do
      # include the Smithy helpers in the host application
      ::ApplicationController.send :helper, Smithy::Engine.helpers
    end

    config.generators do |g|
      g.test_framework :rspec, :fixture => false, :view_specs => false
      g.integration_tool :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    config.after_initialize do
      # we need to require all our model files so that ContentBlocks
      # are registered with the engine
      Dir[Smithy::Engine.root.join('app', 'models', 'smithy', '*.rb')].each do |file|
        require_dependency file if ActiveRecord::Base.connection.table_exists?(file.pluralize)
      end
    end
  end
end
