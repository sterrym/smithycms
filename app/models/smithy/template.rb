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
    after_save :touch_pages

    default_scope order(:name)
    scope :javascripts, where(:template_type => "javascript")
    scope :partials, where(:template_type => "include")
    scope :stylesheets, where(:template_type => "stylesheet")
    scope :templates, where(:template_type => "template")

    class << self
      def types
        %w(template include javascript stylesheet)
      end
    end

    def liquid_template
      @liquid_template ||= Rails.cache.fetch("#{self.cache_key}-liquid_template") do
        ::Liquid::Template.parse(self.content)
      end
    end

    private
      def load_containers
        return unless self.template_type == 'template'
        container_names = liquid_template.root.nodelist.select{|n| n.is_a?(::Liquid::Variable) && n.name.match(/^page\.container\.(.*)/) }.map{|n| n.name.match(/^page\.container\.(.*)/)[1] }
        self.containers = container_names.map{|container_name| Smithy::TemplateContainer.new(:name => container_name) }
      end

      def touch_pages
        self.pages.each(&:touch)
      end

      def uncache_liquid_template_if_content_changed
        @liquid_template = nil if self.content_changed?
      end
  end
end
