module Drupal
  class ProfileField < Base
    set_primary_key "fid"
    self.inheritance_column = nil
    has_and_belongs_to_many :users, :class_name => "Drupal::User", :join_table => "profile_values", :foreign_key => "fid", :association_foreign_key => "uid"

    def value
      @unserialized_value ||= case self[:type]
        when "checkbox" then super != "0"
        when "url" then URI.parse(super)
        when "date"
          hash = Serialize.unserialize(super)
          Date.new(hash["year"].to_i, hash["month"].to_i, hash["day"].to_i)
        when "list" then super.split(/[,\n\r]/).map(&:strip)
        else super
      end
    end
  end
end
