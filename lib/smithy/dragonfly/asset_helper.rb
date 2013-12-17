module Smithy
  module Dragonfly
    module AssetHelper

      extend ActiveSupport::Concern
      included do
        before_save :set_content_types
      end

      module ClassMethods
        def content_types
          {
            :image      => ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg', 'image/x-icon'],
            :media      => [/^video/, 'application/x-shockwave-flash', 'application/x-flash-video', 'application/x-swf', /^audio/, 'application/ogg', 'application/x-mp3'],
            :pdf        => ['application/pdf', 'application/x-pdf'],
            :stylesheet => ['text/css'],
            :javascript => ['text/javascript', 'text/js', 'application/x-javascript', 'application/javascript', 'text/x-component'],
            :font       => ['application/x-font-ttf', 'application/vnd.ms-fontobject', 'image/svg+xml', 'application/x-woff']
          }
        end

        def dragonfly_datastore
          if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_S3_BUCKET'].present?
            datastore = ::Dragonfly::DataStorage::S3DataStore.new
            datastore.configure do |c|
              c.bucket_name = ENV['AWS_S3_BUCKET']
              c.access_key_id = ENV['AWS_ACCESS_KEY_ID']
              c.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
              # c.region = 'eu-west-1'                        # defaults to 'us-east-1'
              # c.storage_headers = {'some' => 'thing'}       # defaults to {'x-amz-acl' => 'public-read'}
              # c.url_scheme = 'https'                        # defaults to 'http'
              # c.url_host = 'some.custom.host'               # defaults to "<bucket_name>.s3.amazonaws.com"
            end
          else
            datastore = ::Dragonfly::DataStorage::FileDataStore.new
          end
          datastore
        end

        def dragonfly_remote_datastore
          ::Smithy::Dragonfly::DataStorage::RemoteDataStore.new
        end

      end

      def set_content_types
        # empty by default - override in your own models if you need to use it
      end

      def set_content_type(file, content_type_column)
        return unless file.present?
        value = :other
        content_type = file.mime_type
        self.class.content_types.each_pair do |type, rules|
          rules.each do |rule|
            case rule
            when String then value = type if content_type == rule
            when Regexp then value = type if (content_type =~ rule) == 0
            end
          end
        end
        self[content_type_column] = value.to_s
      end

    end
  end
end
