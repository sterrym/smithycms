module Smithy
  class Page < ActiveRecord::Base
    attr_accessible :browser_title, :cache_length, :description, :keywords, :permalink, :published_at, :show_in_navigation, :title, :parent_id, :template_id

    validates_presence_of :path, :template, :template_id, :title
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
    # after_move :update_path # this is a acts_as_nested_set callback

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

    def normalize_friendly_id(value)
      if self.parent.blank?
        '/'
      else
        self.permalink? ? self.permalink.parameterize : value.to_s.parameterize
        [(self.parent.present? && !self.parent.root? ? self.parent.path : nil), value.to_s.parameterize].join('/')
      end
    end

    def container_names
      @container_names ||= containers.map(&:name)
    end

    def generated_browser_title
      self.self_and_ancestors.map(&:title).join(' | ')
    end

    def render
      template.liquid_template.render('page' => self)
    end

    def render_container(container_name)
      self.contents.where(:container => container_name).map(&:render).join
    end

    def to_liquid
      {
        'browser_title' => browser_title || generated_browser_title,
        'title' => title,
        'meta_description' => description,
        'meta_keywords' => keywords,
        'container' => self.container_names.inject({}) {|container, stack| stack[container] = render_container(container) }
      }
    end

    private
      def build_permalink
        self.permalink = self.root? ? title.parameterize   : path.split('/').last unless self.permalink?
      end

      # def update_path
      #   updated_path = self_and_ancestors.map{|page| page.root? ? '' : page.permalink }.join('/')
      #   self.update_attribute(:path, updated_path)
      # end

      def validate_exclusion_of_reserved_words
        reserved = %w(index new session login logout users smithy admin)
        errors.add(:title, "cannot contain reserved words (#{reserved.join(', ')})") if reserved.include?(self.title.to_s.parameterize)
      end

      def validate_one_root
        errors.add(:parent_id, 'must have a parent') if self.class.root && self.parent_id.blank?
      end

  end
end
