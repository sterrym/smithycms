module Smithy
  module Liquid
    module Filters
      module SmithyHelpers
        def rails_helper(helper, *args)
          options = args_to_options(args)
          helper = helper.to_sym
          return nil if !controller.view_context.respond_to?(helper)
          if options.blank?
            controller.view_context.public_send(helper)
          else
            controller.view_context.public_send(helper, options)
          end
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

      end
      ::Liquid::Template.register_filter(SmithyHelpers)
    end
  end
end
