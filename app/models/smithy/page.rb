module Smithy
  class Page < ActiveRecord::Base
    attr_accessible :browser_title, :cache_length, :description, :keywords, :permalink, :published_at, :show_in_navigation, :title, :parent_id, :template_id

    validates_presence_of :template, :title
    validate :validate_one_root
    validate :validate_exclusion_of_reserved_words

    belongs_to :template
    has_many :containers, :through => :template
    has_many :contents, :class_name => "PageContent"

    acts_as_nested_set :dependent => :destroy
    extend FriendlyId
    friendly_id :title, :use => [:slugged, :scoped],
                :slug_column => 'path',
                :scope => :parent_id

    before_save :build_permalink

    accepts_nested_attributes_for :contents, :reject_if => lambda {|a| a['label'].blank? || a['container'].blank? || a['content_block'].blank? }, :allow_destroy => true

    class << self
      def tree_for_select
        tree_for_select = []
        each_with_level(root.self_and_descendants) do |page, level|
          prepend = level == 0 ? "" : "#{'-' * level} "
          tree_for_select << [ "#{prepend}#{page.title}", page.id]
        end if root.present?
        tree_for_select
      end
    end

    def container_names
      @container_names ||= containers.map(&:name)
    end

    def generated_browser_title
      self.self_and_ancestors.map(&:title).join(' | ')
    end

    # normalize_friendly_id overrides the default creator for friendly_id
    def normalize_friendly_id(value)
      if self.parent.blank?
        '/'
      else
        value = self.permalink? ? self.permalink.parameterize : value.to_s.parameterize
        [(self.parent.present? && !self.parent.root? ? self.parent.path : nil), value].join('/')
      end
    end

    def render
      template.liquid_template.render('page' => self)
    end

    def render_container(container_name)
      self.contents.where(:container => container_name).map(&:render).join("\n\n")
    end

    def rendered_containers
      rendered_containers = {}
      self.container_names.each{|cn| rendered_containers[cn] = render_container(cn) }
      rendered_containers
    end

    def to_liquid
      {
        'browser_title' => browser_title || generated_browser_title,
        'title' => title,
        'meta_description' => description,
        'meta_keywords' => keywords,
        'container' => rendered_containers
      }
    end

    private
      def build_permalink
        self.permalink = self.root? ? title.parameterize : path.split('/').last unless self.permalink?
      end

      def validate_exclusion_of_reserved_words
        reserved = %w(index new edit session login logout users smithy)
        errors.add(:title, "cannot contain reserved words (#{reserved.join(', ')})") if reserved.include?(self.title.to_s.parameterize)
      end

      def validate_one_root
        errors.add(:parent_id, 'must have a parent') if self.class.root && self.parent_id.blank?
      end

  end
end
