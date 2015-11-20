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

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( ZeroClipboard.swf )
    end

    config.after_initialize do
      # We need to reload the routes here due to how Smithy sets them up.
      # The different facets of Smithy (auth) append/prepend routes to Smithy
      # *after* the main engine has been loaded.
      #
      # So we wait until after initialization is complete to do one final reload.
      # This then makes the appended/prepended routes available to the application.
      Rails.application.routes_reloader.reload!
      # we need to require all our model files so that ContentBlocks
      # are registered with the engine
      Dir[Smithy::Engine.root.join('app', 'models', 'smithy', '*.rb')].each do |file|
        table_name = File.basename(file, '.rb').pluralize
        require_dependency file if ActiveRecord::Base.connection.table_exists?(table_name)
      end
    end

    # TODO: Abstract out the configuration
    # initializer "smithy.config", :before => :load_config_initializers do |app|
    #   Smithy::Config = app.config.smithy.preferences
    # end

  end
end
