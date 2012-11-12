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
      elsif source.respond_to?(:url) # carrierwave uploader
        if source.file.respond_to?(:url)
          file = self.app.fetch_url(source.url) # amazon s3, cloud files, ...etc
        else
          file = self.app.fetch_file(source.path)
        end
      else
        Smithy.log :error, "Unable to resize on the fly: #{source.inspect}"
        return
      end

      file.process(:thumb, resize_string).url
    end

    def self.app
      ::Dragonfly[:files]
    end

  end
end
