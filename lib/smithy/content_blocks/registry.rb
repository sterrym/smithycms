require 'active_support/concern'
module Smithy
  module ContentBlocks
    class Registry
      @@content_blocks = []

      class << self
        def clear
          @@content_blocks = []
        end

        def content_blocks
          @@content_blocks
        end

        def register(content_block, description = nil)
          @@content_blocks << content_block.to_s unless @@content_blocks.include?(content_block.to_s)
          cb = Smithy::ContentBlock.find_or_initialize_by_name(content_block.to_s)
          cb.description = description
          cb.save
          @@content_blocks
        end
      end
    end
  end
end
