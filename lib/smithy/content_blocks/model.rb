module Smithy
  module ContentBlocks
    module Model
      extend ActiveSupport::Concern
      included do
        has_many :page_contents, :as => :content_block
        Smithy::ContentBlocks::Registry.register self.to_s.demodulize, self.content_block_description
      end

      module ClassMethods
        def content_block_description
        end
      end
    end
  end
end
