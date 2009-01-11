require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::ProfileField do
  it "should return textfield as string" do
    field = Drupal::ProfileField.new(:type => "textfield")
    field["value"] = "Hello, World!"
    field.value.should == "Hello, World!"
  end

  it "should return textarea as a string" do
    field = Drupal::ProfileField.new(:type => "textarea")
    field["value"] = "This is one line\nThis is another line"
    field.value.should == "This is one line\nThis is another line"
  end

  it "should return selection as a string" do
    field = Drupal::ProfileField.new(:type => "selection")
    field["value"] = "Hello, World!"
    field.value.should == "Hello, World!"
  end

  it "should return URL as a URI" do
    field = Drupal::ProfileField.new(:type => "url")
    field["value"] = "http://flibble.com"
    field.value.should == URI.parse("http://flibble.com")
  end

  it "should return date as a date" do
    field = Drupal::ProfileField.new(:type => "date")
    field["value"] = "a:3:{s:5:\"month\";s:1:\"6\";s:3:\"day\";s:2:\"25\";s:4:\"year\";s:4:\"2008\";}"
    field.value.should == Date.new(2008, 6, 25)
  end

  it "should return comma-separated list as an aray" do
    field = Drupal::ProfileField.new(:type => "list")
    field["value"] = "a,b,c,d"
    field.value.should == ["a", "b", "c", "d"]
  end

  it "should return end-of-line-separated list as an aray" do
    field = Drupal::ProfileField.new(:type => "list")
    field["value"] = "a\nb\nc\nd"
    field.value.should == ["a", "b", "c", "d"]
  end

  it "should strip blanks from list values" do
    field = Drupal::ProfileField.new(:type => "list")
    field["value"] = " a , b , c , d "
    field.value.should == ["a", "b", "c", "d"]
  end

  it "should return checkbox value '0' as a false" do
    field = Drupal::ProfileField.new(:type => "checkbox")
    field["value"] = "0"
    field.value.should == false
  end

  it "should return checkbox value '1' as a true" do
    field = Drupal::ProfileField.new(:type => "checkbox")
    field["value"] = "1"
    field.value.should == true
  end
end
