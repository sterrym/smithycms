module Smithy
  class Asset < ActiveRecord::Base
    validates_presence_of :file, :name

    has_many :images, :dependent => :destroy

    extend ::Dragonfly::Model
    dragonfly_accessor :file
    include ::Smithy::Dragonfly::AssetHelper

    before_validation :set_name
    before_save :set_file_uid_manually

    default_scope -> { order(:name) }

    def file
      # check for the jquery uploaded file first, just in case one got past the manual check. Also keeps backwards-compatibility
      if self.uploaded_file_url?
        dragonfly_attachments[:file].app.datastore = self.class.dragonfly_remote_datastore
        self.file_url = URI.escape(self.uploaded_file_url)
      elsif dragonfly_attachments[:file].to_value
        dragonfly_attachments[:file].app.datastore = self.class.dragonfly_datastore
      end
      dragonfly_attachments[:file].to_value
    end

    def file_type
      ext = File.extname(file.name).sub(/^\./, '')
      case ext
      when 'jpg', 'jpeg', 'gif', 'png'
        :image
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

      # this allows dragonfly to take over management of the uploaded file. We are
      # assuming that jquery-upload and dragonfly are using the same data storage...
      def set_file_uid_manually
        if self.uploaded_file_url? # this means it was uploaded via jquery-upload
          self.file_uid = URI.parse(self.uploaded_file_url).path.sub(/^\//, '')
          self.uploaded_file_url = nil
        end
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
