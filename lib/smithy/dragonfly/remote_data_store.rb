require 'httparty'
module Smithy
  module Dragonfly
    module DataStorage
      class RemoteDataStore
        def write(content, opts={})
          # raise "Sorry friend, this datastore is read-only."
        end

        def read(uid)
          response = HTTParty.get uid, :timeout => 3
          raise DataNotFound unless response.ok?
          content = response.body
          extra_data = {}
          [
            content,            # either a File, String or Tempfile
            extra_data          # Hash with optional keys :meta, :name, :format
          ]
        end

        def destroy(uid)
          raise "Sorry friend, this datastore is read-only."
        end
      end
    end
  end
end
