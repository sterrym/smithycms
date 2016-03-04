module Smithy
  class AssetLink
    def self.fix(content)
      content.to_s.gsub(/\/smithy\/assets\/([0-9]+)/) { Smithy::Asset.find($1).url }
    end
  end
end
