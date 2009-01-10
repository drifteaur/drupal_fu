module Drupal
  class SessionStore
    def self.stub(login)    
      self.class_eval <<-EOS
        def initialize_with_stubbing(session, options = {})
          user = Drupal::User.find_or_create_by_name("#{login}")
          user.update_attributes!(:status => 1)
          Drupal::Session.find_or_create_by_sid_and_uid(session.session_id, user.uid)
          initialize_without_stubbing(session, options)
        end
        alias_method_chain :initialize, :stubbing
EOS

      Digest::MD5.hexdigest(login)
    end

    def initialize(session, options = {})
      @session = Drupal::Session.authenticate(session.session_id)
      raise CGI::Session::NoSession, "uninitialized session" if @session.nil?
    end

    # Restore session data from the record.
    def restore
      @data = decode(@session.session)
    end

    # Wait until close to write the session data.
    def update; end

    # Update the database.
    def close
      now = Time.now.to_i
      @session.timestamp = now
      @session.session = encode(@data) if defined?(@data)
      @session.save!
      @session.user.access = now
      @session.user.save!
      @session = nil
      @data = nil
    end

    # This is handled by Drupal.
    def delete
      @session = nil
      @data = nil
    end

    private

      def encode(data)
        data = data.dup
        data.delete(:user)
        data.delete("flash") if data["flash"].blank?
        data
      end

      def decode(data)
        data = data.dup
        flash = data["flash"]
        data["flash"] = ActionController::Flash::FlashHash.new.replace(flash) if flash
        data[:user] = @session.user
        data
      end
  end
end
