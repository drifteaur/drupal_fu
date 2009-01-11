require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::Session do
  it "should use sid as the primary key" do
    Drupal::Session.primary_key.should == "sid"
  end

  it "should authenticate active users" do
    Drupal::Session.should_receive(:find).with(:first, { :conditions => ["sessions.sid = ? AND users.status = 1", "abcdef"], :include => :user }).and_return(:user)
    Drupal::Session.authenticate("abcdef").should == :user
  end
  
  it "should not authenticate blocked users" do
    Drupal::Session.should_receive(:find).with(:first, { :conditions => ["sessions.sid = ? AND users.status = 1", "abcdef"], :include => :user }).and_return(nil)
    Drupal::Session.authenticate("abcdef").should be_nil
  end
  
  it "should encode data" do
    session = Drupal::Session.new
    session.session = { "A" => '"|"', "B" => '"|"' }
    session[:session].should == 'A|s:3:""|"";B|s:3:""|"";'
  end
  
  it "should decode data" do
    session = Drupal::Session.new
    session[:session] = 'A|s:3:""|"";B|s:3:""|"";'
    session.session.should == { "A" => '"|"', "B" => '"|"' }
  end
  
  it "should decode nil as an empty hash" do
    session = Drupal::Session.new
    session[:session] = nil
    session.session.should == {}
  end
end
