require 'active_support/concern'

module Smithy
  module ContentResources
    class Registry
      @@content_resources = []

      class << self
        def clear
          @@content_resources = []
        end

        def content_resources
          @@content_resources
        end

        def register(content_resource_model_name, navigation_title=nil)
          return if @@content_resources.include?(content_resource_model_name)
          navigation_title ||= content_resource_model_name.to_s.titleize.pluralize
          @@content_resources << [content_resource_model_name.to_s.tableize, navigation_title]
          Smithy::Engine.routes.prepend do
            scope '/smithy/content_resources' do
              resources content_resource_model_name.to_s.tableize
            end
          end
          @@content_resources
        end
      end
    end
  end
end
