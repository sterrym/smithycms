module Smithy
  class Asset < ActiveRecord::Base
    validates_presence_of :file, :name

    has_many :images, :dependent => :destroy

    attachment :file

    before_validation :set_name

    default_scope -> { order(:name) }

    def file_type
      case file_content_type
      when /^image\/svg/
        :direct_image
      when /^image\//
        :image
      when /pdf/
        :pdf
      when /msword|wordprocessing/
        :word
      when /excel|spreadsheet/
        :excel
      when /powerpoint|presentation/
        :powerpoint
      when /txt/
        :text
      when /rtf/
        :document
      else
        :default
      end
    end

    def to_liquid
      {
        'id' => self.id,
        'name' => self.name,
        'content_type' => self.file_content_type,
        'file' => self.file,
        'file_name' => self.file_filename,
        'file_width' => self.file_width,
        'file_height' => self.file_height,
        'file_size' => self.file_size,
        'remote_url' => self.file.remote_url,
        'url' => self.file.url
      }
    end

    private
      def set_name
        if self.uploaded_file_url?
          self.name = File.basename(self.uploaded_file_url, '.*').titleize unless self.name?
        elsif self.file.present?
          self.name = File.basename(self.file_filename, '.*').titleize unless self.name?
        end
     end
  end
end
