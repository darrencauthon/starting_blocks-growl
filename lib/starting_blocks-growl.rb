require 'starting_blocks'
require 'ruby-growl'
require File.expand_path(File.dirname(__FILE__) + '/growl_alert')

StartingBlocks::Publisher.subscribers << StartingBlocks::Extensions::GrowlAlert.new
