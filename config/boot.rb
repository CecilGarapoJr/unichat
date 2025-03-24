ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Patch Logger before Rails loads
require 'logger'
require 'concurrent'

module ActiveSupport
  module LoggerThreadSafeLevel
    def local_level
      @local_levels[Thread.current] || level
    end

    def local_level=(level)
      @local_levels[Thread.current] = level
    end

    def after_initialize
      @local_levels = Concurrent::Map.new(initial_capacity: 2)
      self.level = @level
    end
  end

  class Logger < ::Logger
    include LoggerThreadSafeLevel
  end
end

require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
