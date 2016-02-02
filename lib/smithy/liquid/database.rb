module Smithy
  module Liquid
    class Database
      def read_template_file(template_path, context)
        _include = Smithy::Template.partials.where(:name => template_path).first
        raise ActiveRecord::RecordNotFound, "No such template '#{template_path}'" unless _include.present?

        _include.content_with_fixed_asset_links
      end
    end
  end
end
