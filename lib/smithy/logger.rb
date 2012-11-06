module Smithy
  module Logger

    def self.method_missing(meth, message, &block)
      if Smithy.config.enable_logs == true
        Rails.logger.send(meth, "[Smithy] #{message}")
      end
    end

  end
end
