require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::MenuLink do
  it "should provide title as alias for link_title" do
    link = Drupal::MenuLink.new(:link_title => "flibble")
    link.title.should == "flibble"
  end
end
