require 'smithy/dragonfly/asset_helper'
require 'smithy/dragonfly/remote_data_store'
module Smithy
  module Dragonfly

    def self.resize_url(source, resize_string)
      file = nil

      if source.is_a?(String)
        source.strip!
        if source =~ /^http/
          file = self.app.fetch_url(source)
        else
          file = self.app.fetch_file(File.join('public', source))
        end
      elsif source.respond_to?(:url) # dragonfly uploader
        file = source
      else
        Smithy.log :error, "Unable to resize on the fly: #{source.inspect}"
        return
      end
      file.process(:thumb, resize_string).url
    end

    def self.app
      ::Dragonfly.app
    end

  end
end
