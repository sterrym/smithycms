module Smithy
  class Engine < ::Rails::Engine
    isolate_namespace Smithy

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', File.dirname(__FILE__)))
      end
    end

    # app/inputs for formtastic
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/inputs)

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
      icons = %w(_blank _page doc pdf ppt txt xls xlsx)
      Rails.application.config.assets.precompile += %w( ZeroClipboard.swf smithy/logo-sm.png) + icons.map{|icon| "smithy/icons/#{icon}.png" }
    end

    config.after_initialize do
      # We need to reload the routes here due to how Smithy sets them up.
      # The different facets of Smithy (auth) append/prepend routes to Smithy
      # *after* the main engine has been loaded.
      #
      # So we wait until after initialization is complete to do one final reload.
      # This then makes the appended/prepended routes available to the application.
      Rails.application.routes_reloader.reload!
    end

    initializer :content_blocks, :before => :load_config_initializers do |config|
      # register our default ContentBlocks with the engine
      Smithy::ContentBlocks::Registry.register Content
      Smithy::ContentBlocks::Registry.register Image
      Smithy::ContentBlocks::Registry.register PageList
    end

    initializer "smithy.config", :before => :load_config_initializers do |app|
      # TODO: Abstract out the configuration
      # Smithy::Config = app.config.smithy.preferences
    end

  end
end
