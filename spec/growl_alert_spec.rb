require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'subtle'
require File.expand_path(File.dirname(__FILE__) + '/../lib/starting_blocks-growl')
require 'mocha/setup'

describe StartingBlocks::Extensions::GrowlAlert do

  let(:growl_alert) { StartingBlocks::Extensions::GrowlAlert.new }
  let(:growl)       { mock() }

  before do
    Growl.stubs(:new).with('localhost', 'Test Run').returns growl
    growl.expects(:add_notification).with "starting_blocks Notification"
  end

  it "should setup the growl as expected" do
    growl_alert
  end

  describe "receiving files to run" do
    describe "there are files to run" do
      it "should work with first example" do
        growl_alert.expects(:message).with "Starting Test Run", "file"
        growl_alert.receive_files_to_run ["file"]
      end

      it "should work with second example" do
        growl_alert.expects(:message).with "Starting Test Run", "file1, file2"
        growl_alert.receive_files_to_run ["file1", "file2"]
      end

      it "should work with the third example" do
        growl_alert.expects(:message).with "Starting Test Run", "file1, file2, file3"
        growl_alert.receive_files_to_run ["file1", "file2", "file3"]
      end
    end

    describe "no files" do
      it "should not fire a message" do
        growl_alert.expects(:message).never
        growl_alert.receive_files_to_run []
      end
    end
  end

  describe "receiving results" do

    describe "no files were received previously" do
      it "should not fire a message if files were provided" do
        growl_alert.expects(:message).never
        growl_alert.receive_results({})
      end

      it "should not fire a message if no files were received" do
        growl_alert.expects(:message).never
        growl_alert.receive_files_to_run []
        growl_alert.receive_results({})
      end
    end

    describe "files were received previously" do
      before do
        growl_alert.stubs(:message)
        growl_alert.receive_files_to_run ["test"]
      end

      it "should return no tests to run if no tests were run" do
        growl_alert.expects(:message).with "No Tests To Run", ""
        growl_alert.receive_results( { tests: 0 } )
      end

      it "should return a failure with details if provided failures" do
        growl_alert.expects(:message).with "Fail", "1 error"
        growl_alert.receive_results( { errors: 1 } )
      end

      it "should return a failure with details if provided failures" do
        growl_alert.expects(:message).with "Fail", "1 error"
        growl_alert.receive_results( { failures: 1 } )
      end

      it "should return skips if one skip is provided" do
        growl_alert.expects(:message).with "Skipped", "1 skip"
        growl_alert.receive_results( { skips: 1 } )
      end

      it "should return a success if tests passed with no errors, failures, or skips" do
        growl_alert.expects(:message).with "Success", "1 passed"
        growl_alert.receive_results( { tests: 1 } )
      end
    end
  end
end
