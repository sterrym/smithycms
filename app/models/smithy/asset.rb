module Smithy
  class Asset < ActiveRecord::Base
    validates_presence_of :file, :name

    has_many :images, :dependent => :destroy

    before_validation :set_name
    before_save :set_file_uid_manually

    default_scope -> { order(:name) }

    def file_type
      ext = File.extname(file.name).sub(/^\./, '')
      case ext
      when 'jpg', 'jpeg', 'gif', 'png'
        :image
      when 'svg', 'svgz'
        :direct_image
      when 'pdf'
        :pdf
      when 'doc', 'docx'
        :word
      when 'xls', 'xlsx'
        :excel
      when 'ppt', 'pps', 'pptx', 'ppsx'
        :powerpoint
      when 'txt'
        :text
      when 'rtf'
        :document
      else
        :default
      end
    end

    def to_liquid
      {
        'id' => self.id,
        'name' => self.name,
        'content_type' => self.content_type,
        'file' => self.file,
        'file_name' => self.file_name,
        'file_width' => self.file_width,
        'file_height' => self.file_height,
        'file_size' => self.file_size,
        'remote_url' => self.file.remote_url,
        'url' => self.file.url
      }
    end

    private
      def set_content_types
        set_content_type(self.file, :content_type)
      end

      def set_name
        if self.uploaded_file_url?
          self.name = File.basename(self.uploaded_file_url, '.*').titleize unless self.name?
        elsif self.file.present?
          self.name = File.basename(self.file.name, '.*').titleize unless self.name?
        end
     end
  end
end
