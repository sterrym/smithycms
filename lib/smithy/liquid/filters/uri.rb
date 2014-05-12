module Smithy
  module Liquid
    module Filters
      module Uri
        def urlescape(input)
          ::CGI::escape(input.to_s)
        end
        def urlunescape(input)
          ::CGI.unescape(input.to_s)
        end
      end
      ::Liquid::Template.register_filter(Uri)
    end
  end
end
