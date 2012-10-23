module Liquid
  class Database
    def read_template_file(template_path, context)
      _include = Smithy::Template.where(:template_type => 'include').where(:name => template_path).first
      raise ActiveRecord::RecordNotFound, "No such template '#{template_path}'" unless _include.present?

      _include.content
    end
  end
end
