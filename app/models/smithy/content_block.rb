module Smithy
  class ContentBlock < ActiveRecord::Base
    validates_presence_of :name

    has_many :templates, :class_name => "ContentBlockTemplate"
    has_many :page_contents

    after_save :touch_page_contents

    accepts_nested_attributes_for :templates, :reject_if => lambda {|a| a['name'].blank? || a['content'].blank? }, :allow_destroy => true

    default_scope -> { order(:name) }

    def description
      klass.content_block_description if klass
    end

    def content_field_names
      unless @content_field_names
        if klass.new.respond_to?(:to_liquid)
          @content_field_names = klass.new.to_liquid.keys
        else
          @content_field_names = klass.column_names.delete_if{|column_name| ["id", "created_at", "updated_at"].include?(column_name) }
        end
      end
      @content_field_names
    end

    private
      def klass
        @klass ||= "#{self.name}".safe_constantize || "Smithy::#{self.name}".safe_constantize
      end

      def touch_page_contents
        self.page_contents.each(&:touch)
      end

  end
end
