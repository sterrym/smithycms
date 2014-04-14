module Smithy
  module ContentBlocks
    module Model
      extend ActiveSupport::Concern
      included do
        has_many :page_contents, as: :content_block, class_name: 'Smithy::PageContent'
        Smithy::ContentBlocks::Registry.register self
      end

      module ClassMethods
        def content_block_description
        end
      end
    end
  end
end
