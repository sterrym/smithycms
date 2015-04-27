require "aws-sdk"
require "open-uri"

module Refile
  module Backend
    # A refile backend which stores files in Amazon S3
    #
    # @example
    #   backend = Refile::Backend::S3.new(
    #     access_key_id: "xyz",
    #     secret_access_key: "abcd1234",
    #     bucket: "my-bucket",
    #     prefix: "files"
    #   )
    #   file = backend.upload(StringIO.new("hello"))
    #   backend.read(file.id) # => "hello"
    class S3Reader < S3
      # Sets up an S3 backend with the given credentials.
      #
      # @param [String] access_key_id
      # @param [String] secret_access_key
      # @param [String] bucket            The name of the bucket where files will be stored
      # @param [Integer, nil] max_size    The maximum size of an uploaded file
      # @param [#hash] hasher             A hasher which is used to generate ids from files
      # @param [Hash] s3_options          Additional options to initialize S3 with
      # @see http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/Core/Configuration.html
      # @see http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3.html
      def initialize(*args)
        super(args.delete_if{|k,v| k == :prefix})
      end

      # Get a file from this backend.
      #
      # Note that this method will always return a {Refile::File} object, even
      # if a file with the given id does not exist in this backend. Use
      # {FileSystem#exists?} to check if the file actually exists.
      #
      # @param [Sring] id           The id of the file
      # @return [Refile::File]      The retrieved file
      def get(id)
        Refile::File.new(self, id)
      end

      # Delete a file from this backend
      #
      # @param [Sring] id           The id of the file
      # @return [void]
      def delete(id)
        object(id).delete
      end

      # Return an IO object for the uploaded file which can be used to read its
      # content.
      #
      # @param [Sring] id           The id of the file
      # @return [IO]                An IO object containing the file contents
      def open(id)
        Kernel.open(object(id).url_for(:read))
      end

      # Return the entire contents of the uploaded file as a String.
      #
      # @param [String] id           The id of the file
      # @return [String]             The file's contents
      def read(id)
        object(id).read
      rescue AWS::S3::Errors::NoSuchKey
        nil
      end

      # Return the size in bytes of the uploaded file.
      #
      # @param [Sring] id           The id of the file
      # @return [Integer]           The file's size
      def size(id)
        object(id).content_length
      rescue AWS::S3::Errors::NoSuchKey
        nil
      end

      # Return whether the file with the given id exists in this backend.
      #
      # @param [Sring] id           The id of the file
      # @return [Boolean]
      def exists?(id)
        object(id).exists?
      end

      def object(id)
        @bucket.objects[[*@prefix, id].join("/")]
      end
    end
  end
end
