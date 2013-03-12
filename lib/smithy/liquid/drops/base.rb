module Smithy
  module Liquid
    module Drops
      class Base < ::Liquid::Drop
        attr_reader :_source
        def initialize(source)
          @_source = source
        end

        def id
          (@_source.respond_to?(:id) ? @_source.id : nil) || 'new'
        end
      end
    end
  end
end
