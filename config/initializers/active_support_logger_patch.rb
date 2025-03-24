require 'logger'

module ActiveSupport
  module LoggerThreadSafeLevel
    def after_initialize
      @local_levels = Concurrent::Map.new(initial_capacity: 2)
      self.level = @level # Initialize logging level for the current thread
    end
  end
end

# Ensure Logger is loaded
Object.const_set(:Logger, ::Logger) unless defined?(::Logger)

# Configure Rails logger
Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)) if defined?(Rails) && Rails.respond_to?(:logger)
