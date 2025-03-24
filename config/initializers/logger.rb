require 'logger'
require 'active_support/logger'

# Ensure the Logger constant is available
Object.const_set(:Logger, ::Logger) unless defined?(::Logger)

# Configure Rails logger
Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
