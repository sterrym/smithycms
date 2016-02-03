require "smithy/engine"
# libraries
require 'smithy/dependencies'
# config
require 'smithy/logger'
require 'smithy/liquid'
# content formatting
require 'smithy/asset_link'
require 'smithy/formatter'
#
require 'smithy/content_blocks'
require 'smithy/content_resources'

module Smithy
  def self.log(*args)
    level   = args.size == 1 ? 'info' : args.first
    message = args.size == 1 ? args.first : args.last
    ::Smithy::Logger.send(level.to_sym, message)
  end
end
