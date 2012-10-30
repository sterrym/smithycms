module Smithy
  class ContentBlock < ActiveRecord::Base
    attr_accessible :name, :description, :templates_attributes

    validates_presence_of :name

    has_many :templates, :class_name => "ContentBlockTemplate"

    accepts_nested_attributes_for :templates, :reject_if => lambda {|a| a['name'].blank? || a['content'].blank? }, :allow_destroy => true

    default_scope order(:name)

    def content_field_names
      @content_field_names ||= klass.column_names.delete_if{|column_name| ["id", "created_at", "updated_at"].include?(column_name) }
    end

    private
      def klass
        @klass ||= "Smithy::#{self.name}".constantize
      end
  end
end
