require File.dirname(__FILE__) + '/../../spec_helper'

describe Drupal::Authlogic::CryptoProvider do
  HASH = "a029d0df84eb5549c641e04a9ef389e5"

  it "should encrypt a password" do
    Drupal::Authlogic::CryptoProvider.encrypt("mypass").should == HASH
  end

  it "should ignore all but the password token when encrypting" do
    Drupal::Authlogic::CryptoProvider.encrypt("mypass", "mysalt").should == HASH
  end

  it "should match a password" do
    Drupal::Authlogic::CryptoProvider.matches?(HASH, "mypass").should be_true
  end

  it "should ignore all but the password token when encrypting" do
    Drupal::Authlogic::CryptoProvider.matches?(HASH, "mypass", "mysalt").should be_true
  end

  it "should not match an incorrect password" do
    Drupal::Authlogic::CryptoProvider.matches?("a029d0df84eb5549c641e04a9ef389e6", "mypass").should_not be_true
  end
end
