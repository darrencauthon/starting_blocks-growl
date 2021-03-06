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
        return if @spec_count.to_i == 0
        if results[:skips].to_i > 0
          message "Skipped", "1 skip"
        end
        if results[:errors].to_i > 0
          message "Fail", "#{results[:errors]} error"
        elsif results[:failures].to_i > 0
          message "Fail", "#{results[:failures]} error"
        elsif results[:tests].to_i > 0
          message "Success", "#{results[:tests]} passed"
        else
          message "No Tests To Run", ""
        end
      end

      def message title, message
        @g.notify GROWL_ID, title, message
      end
    end
  end
end
