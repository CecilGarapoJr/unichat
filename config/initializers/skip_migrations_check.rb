# frozen_string_literal: true

# This initializer bypasses the pending migrations check
# This is useful for development environments where we want to run the application
# without applying all migrations, especially those requiring special extensions

module ActiveRecord
  class MigrationContext
    def needs_migration?
      false
    end
  end

  class Migration
    class << self
      # Override the check_pending! method to do nothing
      def check_pending!(_connection = nil)
        # Skip the check
      end
    end
  end
end
