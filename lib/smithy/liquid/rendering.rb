module Smithy
  module Liquid
    module Rendering

      private

      def render_smithy_page
        context = ::Liquid::Context.new({}, smithy_default_assigns, smithy_default_registers, false)
        output = @page.template.liquid_template.render(context)
        render :text => output, :layout => false
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
        }
      end

      def smithy_default_registers
        {
          :controller => self,
          :page => @page,
          :site => Smithy::Site.new,
        }
      end
    end
  end
end
