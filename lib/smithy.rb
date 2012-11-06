require "smithy/engine"
# config
require 'smithy/logger'
require 'smithy/dragonfly'

module Smithy

  def self.log(*args)
    level   = args.size == 1 ? 'info' : args.first
    message = args.size == 1 ? args.first : args.last
    ::Smithy::Logger.send(level.to_sym, message)
  end

end
