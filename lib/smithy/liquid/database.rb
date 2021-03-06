module Smithy
  module Liquid
    class Database
      def read_template_file(template_path, context)
        _include = Smithy::Template.partials.where(:name => template_path).first
        raise ActiveRecord::RecordNotFound, "No such template '#{template_path}'" unless _include.present?
        Smithy::AssetLink.fix(_include.content)
      end
    end
  end
end
