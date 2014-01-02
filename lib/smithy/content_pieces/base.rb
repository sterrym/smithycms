module Smithy
  module ContentPieces
    module Base
      extend ActiveSupport::Concern
      included do
        Smithy::ContentPieces::Registry.register self
      end
    end
  end
end
