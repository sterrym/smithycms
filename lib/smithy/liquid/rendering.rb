module Smithy
  module Liquid
    module Rendering

      private

      def render_smithy_page
        if smithy_current_user
          output = @page.render(liquid_context)
        else
          output = Rails.cache.fetch("#{@page.cache_key}-render_smithy_page") do
            @page.render(liquid_context)
          end
        end
        render :text => output, :layout => false
      end

      def render_as_smithy_page(template_name)
        output = Smithy::Template.templates.find_by_name(template_name).liquid_template.render(liquid_context)
        render :text => output, :layout => false
      end

      def liquid_context
        ::Liquid::Context.new({}, smithy_default_assigns, smithy_default_registers, !Rails.env.production?)
      end

      def smithy_default_assigns
        {
          'page'              => @page,
          'current_page'      => self.params[:path],
          'params'            => self.params,
          'path'              => request.path,
          'fullpath'          => request.fullpath,
          'url'               => request.url,
          'now'               => Time.now.utc,
          'today'             => Date.today,
          'site'              => @page.site
        }
      end

      def smithy_default_registers
        {
          :controller => self,
          :page => @page,
          :site => @page.site
        }
      end
    end
  end
end
