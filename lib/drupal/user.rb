module Drupal
  class User < Base
    set_primary_key "uid"
    has_many :sessions, :foreign_key => "sid", :class_name => "Drupal::Session"
    has_and_belongs_to_many :profile_fields, :class_name => "Drupal::ProfileField", :join_table => "profile_values", :foreign_key => "uid", :association_foreign_key => "fid"
    has_many :openids, :foreign_key => "uid", :class_name => "Drupal::Authmap", :conditions => { :module => "openid" }
    serializes "data"
    
    def self.authenticate(name, password)
      find_by_name_and_pass_and_status(name, Digest::MD5.hexdigest(password), 1)
    end
  
    def active?
      status == 1
    end
    
    def administrator?
      uid == 1
    end
  end
end
