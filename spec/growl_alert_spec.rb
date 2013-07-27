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
end
