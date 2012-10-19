module Tagcms
  class Page < ActiveRecord::Base
    attr_accessible :browser_title, :cache_length, :description, :keywords, :permalink, :published_at, :show_in_navigation, :title, :parent_id, :template_id

    validates_presence_of :permalink, :template_id, :title
    validate :validate_one_root

    belongs_to :template
    has_many :containers, :through => :template
    has_many :contents, :class_name => "PageContent"

    acts_as_nested_set :dependent => :destroy
    extend FriendlyId
    friendly_id :title, :use => [:slugged, :scoped],
                :slug_column => 'permalink',
                :scope => :parent_id,
                :reserved_words => %w(index new session login logout users tagcms admin)

    after_validation :move_friendly_id_error_to_title
    after_move :build_path # this is a acts_as_nested_set callback

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
      # the code will be something like this
      # self.contents.where(:container => container_name).map(&:render)
      nil
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
      def build_path
        self.update_attribute(:path, self_and_ancestors.map{|page| page.root? ? '' : page.permalink }.join('/'))
      end

      def move_friendly_id_error_to_title
        errors.add :title, *errors.delete(:friendly_id) if errors[:friendly_id].present?
      end

      def validate_one_root
        errors.add(:parent_id, 'must have a parent') if self.class.root && self.parent_id.blank?
      end

  end
end
