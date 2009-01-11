require File.dirname(__FILE__) + '/../spec_helper'

describe "Drupal::Helper" do
  cattr_accessor :helper_methods
  def self.helper_method(*helper_methods)
    self.helper_methods = helper_methods
  end

  include Drupal::Helper

  ["site_slogan", "site_name"].each do |name|
    it "should return the value of #{name} variable" do
      Drupal::Variable.should_receive(:value_of).with(name).and_return("the value")
      self.send(name).should == "the value"
    end
  end

  it "should lookup the login link" do
    Drupal::UrlAlias.should_receive(:url_for).with("/user/login").and_return("the url")
    self.login_path.should == "the url"
  end
  
  [:primary_links, :login_path, :site_name, :site_slogan].each do |name|
    it "should create helper method for '#{name}'" do
      helper_methods.should include(name)
    end
  end
  
  it "should lookup primary links in database" do
    Drupal::MenuLink.should_receive(:find).with(:all,
          :joins => :menu_router,
          :conditions => ["menu_name = ? AND hidden = 0 AND menu_router.access_callback <> 'user_is_anonymous'", "primary-links"],
          :order => "weight",
          :readonly => true).and_return(["the links"])
    self.primary_links.should == ["the links"]
  end
end
