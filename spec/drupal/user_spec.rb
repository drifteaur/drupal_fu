require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::User do
  it "should use uid as the primary key" do
    Drupal::User.primary_key.should == "uid"
  end

  it "should be active when status != 0" do
    user = Drupal::User.new(:status => 1)
    user.should be_active
  end

  it "should not be active when status == 0" do
    user = Drupal::User.new(:status => 0)
    user.should_not be_active
  end

  it "should be administrator when uid == 1" do
    user = Drupal::User.new { |user| user.uid = 1 }
    user.should be_administrator
  end

  it "should not be administrator when uid != 1" do
    user = Drupal::User.new { |user| user.uid = 37 }
    user.should_not be_administrator
  end

  it "should serialize the data" do
    user = Drupal::User.new
    Drupal::Serialize.should_receive(:serialize).with(:unserialized).and_return(:serialized)
    user.data = :unserialized
    user[:data].should == :serialized
  end

  it "should unserialize the value" do
    user = Drupal::User.new
    Drupal::Serialize.should_receive(:unserialize).with(:serialized).and_return(:unserialized)
    user[:data] = :serialized
    user.data.should == :unserialized
  end
  
  it "should authenticate active users" do
    Drupal::User.should_receive(:find_by_name_and_pass_and_status).with("test", "3858f62230ac3c915f300c664312c63f", 1).and_return(:user)
    Drupal::User.authenticate("test", "foobar").should == :user
  end
  
  it "should not authenticate blocked users" do
    Drupal::User.should_receive(:find_by_name_and_pass_and_status).and_return(nil)
    Drupal::User.authenticate("test", "foobar").should be_nil
  end
end
