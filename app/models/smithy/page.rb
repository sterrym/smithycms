module Smithy
  class Page < ActiveRecord::Base
    validates_presence_of :template, :title
    validate :validate_one_root
    validate :validate_exclusion_of_reserved_words
    validate :validate_duplicate_page_exists

    belongs_to :template
    has_many :containers, :through => :template
    has_many :contents, :class_name => "PageContent"

    acts_as_nested_set :dependent => :destroy
    extend FriendlyId
    friendly_id :title, :use => [:slugged, :scoped], :slug_column => 'path', :scope => :parent_id

    before_save :build_permalink
    before_save :set_published_at
    before_save :copy_content_from_duplicate, on: :create, if: -> { self.duplicate_page.present? }

    accepts_nested_attributes_for :contents, :reject_if => lambda {|a| a['label'].blank? || a['container'].blank? || a['content_block'].blank? }, :allow_destroy => true

    scope :included_in_navigation, -> { where("show_in_navigation=? AND published_at <= ?", true, Time.now) }
    scope :published, -> { where('published_at <= ?', Time.now) }

    attr_accessor :publish, :duplicate_page
    attr_reader :liquid_context

    def self.page_selector_options
      items = Array(self.roots)
      result = []
      items.each do |root|
        result += Page.associate_parents(root.self_and_descendants).map do |i|
          ["#{'-' * i.level} #{i.title}", i.url]
        end.compact
      end
      result
    end

    def container?(container_name)
      containers.where(:name => container_name).count > 0
    end

    def contents_for_container_name(container_name)
      self.contents.publishable.for_container(container_name)
    end

    def normalize_friendly_id(value) # normalize_friendly_id overrides the default creator for friendly_id
      return "/" if self.parent.blank?
      value = self.permalink? ? self.permalink.parameterize : value.to_s.parameterize
      [(self.parent.present? && !self.parent.root? ? self.parent.path : nil), value].join('/')
    end

    def should_generate_new_friendly_id?
      title_changed? || permalink_changed?
    end

    def published?
      self.published_at?
    end

    def render(liquid_context)
      @liquid_context = liquid_context
      self.template.liquid_template.render(liquid_context)
    end

    def render_container(container_name)
      return '' unless container?(container_name)
      Rails.cache.fetch(self.container_cache_key(container_name)) do
        self.contents_for_container_name(container_name).map{|c| c.render(liquid_context) }.join("\n\n")
      end
    end

    def site
      @site ||= Smithy::Site.instance
    end

    def to_liquid
      Smithy::Liquid::Drops::Page.new(self)
    end

    def url
      self.external_link.present? ? self.external_link : self.path
    end

    protected
      def container_cache_key(container_name)
        # fetch the most recently adjusted content and add the updated_at timestamp to the cache_key
        content_last_updated = if self.contents_for_container_name(container_name).count > 0
          self.contents_for_container_name(container_name).order(nil).order('updated_at DESC').first.updated_at
        else
          self.updated_at
        end
        "#{self.cache_key}/#{container_name}-container/#{content_last_updated.utc.to_s(cache_timestamp_format)}"
      end

    private
      def build_permalink
        self.permalink = self.root? ? title.parameterize : path.split('/').last unless self.permalink?
      end

      def copy_content_from_duplicate
        duplicate_page = Page.find(self.duplicate_page)
        duplicate_page.contents.each do |content|
          self.contents << content.dup
        end
      end

      def set_published_at
        self.published_at = Time.now if self.publish.present?
        self.published_at = nil if self.publish == false
      end

      def validate_duplicate_page_exists
        errors.add(:duplicate_page, "this page could not be found. Please choose another and try again.") if self.duplicate_page.present? && Page.find_by(id: self.duplicate_page).blank?
      end

      def validate_exclusion_of_reserved_words
        reserved = %w(index new edit session login logout users smithy)
        errors.add(:title, "cannot contain reserved words (#{reserved.join(', ')})") if reserved.include?(self.title.to_s.parameterize)
      end

      def validate_one_root
        errors.add(:parent_id, 'must have a parent') if self.class.root && self.class.root != self && self.parent_id.blank?
      end

  end
end
