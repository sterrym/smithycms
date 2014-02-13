module Smithy
  class Formatter < ::Slodown::Formatter

    def render
      self.complete.to_s
    end

    private
      def kramdown_options
        { coderay_css: 'style' }
      end

      def sanitize_config
        {
          elements: %w(
            p div ul ol li blockquote pre h1 h2 h3 h4 h5 h6 object
            hr param
            a span sub sup strong em abbr code del small big
            br img
          ),
          attributes: {
            :all     => ['class', 'style', 'title', 'id'],
            'a'      => ['href', 'rel', 'name', 'target'],
            'li'     => ['id'],
            'sup'    => ['id'],
            'img'    => ['src', 'title', 'alt', 'width', 'height'],
            'object' => ['width', 'height'],
            'param'  => ['name', 'value'],
            'embed'  => ['allowscriptaccess', 'width', 'height', 'src'],
            'iframe' => ['width', 'height', 'src']
          },
          protocols: {
            'a' => { 'href' => ['ftp', 'http', 'https', 'mailto', '#fn', '#fnref', :relative] },
            'img' => {'src'  => ['http', 'https', :relative]},
            'iframe' => {'src'  => ['http', 'https']},
            'embed' => {'src'  => ['http', 'https']},
            'object' => {'src'  => ['http', 'https']},
            'li' => {'id' => ['fn']},
            'sup' => {'id' => ['fnref']}
          },
          transformers: ::Slodown::EmbedTransformer
        }
      end
  end
end
