module StartingBlocks
  module Extensions
    class GrowlAlert

      GROWL_ID   = "starting_blocks Notification"
      GROWL_NAME = "Test Run"

      def initialize
        @g = Growl.new "localhost", GROWL_NAME
        @g.add_notification GROWL_ID
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
        @g.notify GROWL_ID, title, message
      end
    end
  end
end
