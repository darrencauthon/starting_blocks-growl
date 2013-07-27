require 'starting_blocks'
require 'ruby-growl'

module StartingBlocks
  module Extensions
    class Growl

      def initialize
        @g = Growl.new "localhost", "Test Run"
        @g.add_notification "starting_blocks Notification"
      end

      def receive_files_to_run files
        @spec_count = files.count
        return if files.count == 0
        message "Starting Test Run", files.join(', ')
      end

      def receive_results results
        return if @spec_count == 0
        if (results[:tests] || 0) == 0
          message "No Tests To Run", ""
        elsif (results[:errors] || 0) > 0
          message "Fail", "#{results[:errors]} errors"
        elsif (results[:failures] || 0) > 0
          message "Fail", "#{results[:failures]} fails"
        elsif (results[:skips] || 0) > 0
          message "Skipped", "#{results[:skips]} skips"
        else
          message "Success", "#{results[:tests]} passed"
        end
      end

      def message title, message
        @g.notify "starting_blocks Notification", title, message
      end
    end
  end
end

StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::Growl.new
