module Smithy
  module ContentBlocks
    module Model
      extend ActiveSupport::Concern
      included do
        has_one :page_content, :as => :content_block, class_name: '::Smithy::PageContent'
        has_one :page, through: :page_content, class_name: '::Smithy::Page'
        Smithy::ContentBlocks::Registry.register self
      end

      module ClassMethods
        def content_block_description
        end
      end
    end
  end
end
