module Smithy
  module ContentResources
    module Base
      extend ActiveSupport::Concern
      included do
        Smithy::ContentResources::Registry.register self
      end
    end
  end
end
