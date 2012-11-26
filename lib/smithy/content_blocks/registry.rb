require 'active_support/concern'
require File.join(File.dirname(__FILE__), '..', '..', '..', 'app', 'models', 'smithy', 'content_block')

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
          return unless ActiveRecord::Base.connection.table_exists? content_block.table_name
          content_block_name = content_block.to_s.demodulize
          @@content_blocks << content_block_name unless @@content_blocks.include?(content_block_name)
          cb = Smithy::ContentBlock.find_or_initialize_by_name(content_block_name)
          cb.description = description
          cb.save
          @@content_blocks
        end
      end
    end
  end
end
