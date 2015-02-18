require 'active_support/concern'

module Smithy
  module ContentPieces
    class Registry
      @@content_pieces = []

      class << self
        def clear
          @@content_pieces = []
        end

        def content_pieces
          @@content_pieces
        end

        def register(content_piece)
          content_piece = content_piece.to_sym
          return if @@content_pieces.include?(content_piece)
          @@content_pieces << content_piece
          Smithy::Engine.routes.prepend do
            scope '/smithy/content_pieces' do
              resources content_piece
            end
          end
          @@content_pieces
        end
      end
    end
  end
end
