module Smithy
  module Liquid
    module Filters
      module AssetTag
        def image_tag(input, *args)
          image_options = args_to_options(args)
          controller.view_context.send(:image_tag, input, image_options)
        end

        protected
          # Convert an array of properties ('key:value') into a hash
          # Ex: ['width:50', 'height:100'] => { :width => '50', :height => '100' }
          def args_to_options(*args)
            options = {}
            args.flatten.each do |a|
              if (a =~ /^(.*):(.*)$/)
                options[$1.to_sym] = $2
              end
            end
            options
          end

          def context
            context = self.instance_variable_get(:@context)
          end

          def controller
            context.registers[:controller]
          end

          # Write options (Hash) into a string according to the following pattern:
          # <key1>="<value1>", <key2>="<value2", ...etc
          def inline_options(options = {})
            return '' if options.empty?
            (options.stringify_keys.sort.to_a.collect { |a, b| "#{a}=\"#{b}\"" }).join(' ') << ' '
          end
      end
      ::Liquid::Template.register_filter(AssetTag)
    end
  end
end
