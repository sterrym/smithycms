module Smithy
  class Asset < ActiveRecord::Base
    attr_accessible :name, :file, :file_name, :file_url, :retained_file, :uploaded_file_url

    validates_presence_of :file, :name

    file_accessor :file
    include Smithy::Dragonfly::AssetHelper

    before_validation :set_name

    def file
      # check for the jquery uploaded file first
      if self.uploaded_file_url?
        dragonfly_attachments[:file].app.datastore = self.class.dragonfly_remote_datastore
        self.file_url = self.uploaded_file_url
      elsif dragonfly_attachments[:file].to_value
        dragonfly_attachments[:file].app.datastore = self.class.dragonfly_datastore
      end
      dragonfly_attachments[:file].to_value
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
        'file_url' => self.file.url
      }
    end

    private
      def set_name
        if self.uploaded_file_url?
          self.name = File.basename(self.uploaded_file_url, '.*').titleize unless self.name?
        elsif self.file.present?
          self.name = File.basename(self.file.name, '.*').titleize unless self.name?
        end
     end
  end
end