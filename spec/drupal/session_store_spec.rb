require File.dirname(__FILE__) + '/../spec_helper'

describe Drupal::SessionStore do
  before(:each) do
    @cgi_session = mock("cgi_session")
    @cgi_session.stub!(:session_id).and_return("abcdefg")
  end

  describe "when no valid session is found" do
    it "should barf if no valid session found" do
      Drupal::Session.should_receive(:authenticate).with("abcdefg").and_return(nil)
      lambda { Drupal::SessionStore.new(@cgi_session) }.should raise_error(CGI::Session::NoSession)
    end
  end
  
  describe "when a valid session is found" do
    before(:each) do
      @user = stub_everything("user")
      @session = stub_everything("session")
      @session.stub!(:user).and_return(@user)
      Drupal::Session.should_receive(:authenticate).with("abcdefg").and_return(@session)
      @store = Drupal::SessionStore.new(@cgi_session)
    end

    describe "and the data is restored" do
      it "should restore aribtrary data" do
        @session.should_receive(:session).and_return("A" => "aye", "B" => "bee")
        data = @store.restore
        data["A"].should == "aye"
        data["B"].should == "bee"
      end

      it "should make the user available" do
        @session.should_receive(:session).and_return({})
        data = @store.restore
        data[:user].should == @user
      end

      it "should not restore a flash if none was serialized" do
        @session.should_receive(:session).and_return({})
        data = @store.restore
        data.should_not have_key("flash")
      end

      it "should restore a flash if one was serialized" do
        @session.should_receive(:session).and_return("flash" => { "A" => "aye" })
        data = @store.restore
        flash = data["flash"]
        flash.should be_instance_of(ActionController::Flash::FlashHash)
        flash.should == { "A" => "aye" }
      end
    end
    
    describe "and is closed" do
      after(:each) do
        @store.close
      end

      it "should set the timestamp" do
        now = Time.now
        Time.stub!(:now).and_return(now)
        @session.should_receive(:timestamp=).with(now.to_i)
      end

      it "should set the users last access" do
        now = Time.now
        Time.stub!(:now).and_return(now)
        @user.should_receive(:access=).with(now.to_i)
      end
      
      it "should serialize arbitrary data" do
        @session.should_receive(:session).and_return("A" => "aye", "B" => "bee")
        @session.should_receive(:session=).with("A" => "aye", "B" => "bee")
        @store.restore
      end

      it "should not serialize the user" do
        @session.should_receive(:session).and_return({})
        @session.should_receive(:session=).with({})
        @store.restore
      end

      it "should not serialize an empty flash" do
        @session.should_receive(:session).and_return("flash" => {})
        @session.should_receive(:session=).with({})
        @store.restore
      end

      it "should serialize a non-empty flash" do
        @session.should_receive(:session).and_return("flash" => { "A" => "aye" })
        @session.should_receive(:session=).with("flash" => { "A" => "aye" })
        @store.restore
      end

      it "should call save" do
        @session.should_receive(:save!)
      end

      it "should save the user" do
        @user.should_receive(:save!)
      end
    end
  end
end
