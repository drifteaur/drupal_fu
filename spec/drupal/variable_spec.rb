require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::Variable do
  it "should serialize the value" do
    variable = Drupal::Variable.new
    Drupal::Serialize.should_receive(:serialize).with("some unserialized value").and_return("the serialized value")
    variable.value = "some unserialized value"
    variable[:value].should == "the serialized value"
  end

  it "should unserialize the value" do
    variable = Drupal::Variable.new
    Drupal::Serialize.should_receive(:unserialize).with("some serialized value").and_return("the unserialized value")
    variable[:value] = "some serialized value"
    variable.value.should == "the unserialized value"
  end

  it "should return the value of an existing variable" do
    variable = mock("variable")
    variable.should_receive(:value).and_return("the value")
    Drupal::Variable.should_receive(:find_by_name).with("some variable name").and_return(variable)
    Drupal::Variable.value_of("some variable name").should == "the value"
  end

  it "should return nil for the value of a missing variable" do
    Drupal::Variable.should_receive(:find_by_name).with("some variable name").and_return(nil)
    Drupal::Variable.value_of("some variable name").should be_nil
  end
end
