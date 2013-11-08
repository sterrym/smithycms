module Smithy
  module UploadHelper
    def uploader_form(object, options = {}, &block)
      # s3_uploader = S3Uploader.new(options)
      # uploader = s3_uploader.s3_available? ? s3_uploader : FileUploader.new(options)
      uploader = S3Uploader.new(options)
      form_tag(uploader.url, uploader.form_options) do
        uploader.fields.map do |name, value|
          hidden_field_tag(name, value)
        end.join.html_safe + capture(&block)
      end
    end

    class Base
      def form_options
        {
          id: @options[:id],
          method: "post",
          authenticity_token: false,
          multipart: true,
          data: {
            post: @options[:post],
            as: @options[:as]
          }
        }
      end
    end

    class FileUploader < Base
      def initialize(options)
        @options = options.reverse_merge( id: "fileupload" )
      end

      def fields
        { :key => key }
      end

      def key
        @key ||= "uploads/assets/${filename}"
      end

      def url
        @options[:post]
      end
    end

    class S3Uploader < Base
      def initialize(options)
        @options = options.reverse_merge(
          id: "fileupload",
          aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
          bucket: ENV["AWS_S3_BUCKET"],
          acl: "public-read",
          expiration: 10.hours.from_now,
          max_file_size: 500.megabytes,
          as: "file"
        )
      end

      def fields
        {
          :key => key,
          :acl => @options[:acl],
          :policy => policy,
          :signature => signature,
          "AWSAccessKeyId" => @options[:aws_access_key_id],
        }
      end

      def key
        @key ||= "uploads/assets/#{SecureRandom.hex}/${filename}"
      end

      def url
        "https://#{@options[:bucket]}.s3.amazonaws.com/"
      end

      def policy
        Base64.encode64(policy_data.to_json).gsub("\n", "")
      end

      def policy_data
        {
          expiration: @options[:expiration].utc.iso8601,
          conditions: [
            ["starts-with", "$utf8", ""],
            ["starts-with", "$key", ""],
            ["content-length-range", 0, @options[:max_file_size]],
            {bucket: @options[:bucket]},
            {acl: @options[:acl]}
          ]
        }
      end

      def signature
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest::Digest.new('sha1'),
            @options[:aws_secret_access_key], policy
          )
        ).gsub("\n", "")
      end

      def s3_available?
        @options[:aws_access_key_id].present? && @options[:aws_secret_access_key].present? && @options[:bucket].present?
      end
    end
  end
end
