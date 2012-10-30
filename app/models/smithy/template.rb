 module Smithy
  class Template < ActiveRecord::Base
    attr_accessible :name, :content, :template_type

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :template_type
    validates_presence_of :content, :on => :update

    has_many :pages
    has_many :containers, :class_name => "TemplateContainer"

    before_save :uncache_liquid_template_if_content_changed
    after_save :load_containers

    default_scope order(:name)
    scope :partials, where(:template_type => "include")
    scope :templates, where(:template_type => "template")

    class << self
      def types
        %w(template include)
      end
    end

    def liquid_template
      @liquid_template ||= Liquid::Template.parse(self.content)
    end

    private
      def load_containers
        container_names = liquid_template.root.nodelist.select{|n| n.is_a?(Liquid::Variable) && n.name.match(/^page\.container\.(.*)/) }.map{|n| n.name.match(/^page\.container\.(.*)/)[1] }
        self.containers = container_names.map{|container_name| Smithy::TemplateContainer.new(:name => container_name) }
      end

      def uncache_liquid_template_if_content_changed
        @liquid_template = nil if self.content_changed?
      end
  end
end
