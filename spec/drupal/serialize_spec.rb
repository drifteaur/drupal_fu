require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::Serialize do
  it "should serialize a simple string" do
    value = Drupal::Serialize.serialize("Hello, World!")
    value.should == "s:13:\"Hello, World!\";"
  end

  it "should unserialize a simple string" do
    value = Drupal::Serialize.unserialize("s:13:\"Hello, World!\";")
    value.should == "Hello, World!"
  end

  it "should serialize a simple hash" do
    value = Drupal::Serialize.serialize("key" => "value")
    value.should == "a:1:{s:3:\"key\";s:5:\"value\";}"
  end

  it "should unserialize a simple hash" do
    value = Drupal::Serialize.unserialize("a:1:{s:3:\"key\";s:5:\"value\";}")
    value.should == { "key" => "value" }
  end

  it "should serialize a simple array" do
    value = Drupal::Serialize.serialize(["key", "value"])
    value.should == "a:2:{i:0;s:3:\"key\";i:1;s:5:\"value\";}"
  end

  it "should unserialize a simple array" do
    value = Drupal::Serialize.unserialize("a:2:{i:0;s:3:\"key\";i:1;s:5:\"value\";}")
    value.should == ["key", "value"]
  end
end
