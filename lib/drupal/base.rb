module Drupal
  class Base < ActiveRecord::Base
    self.establish_connection "drupal_#{RAILS_ENV}"
    self.abstract_class = true
    
    protected

      def self.serializes(*attr_names)
        attr_names.each do |attr_name|
          class_eval <<-EOS
            def #{attr_name}
              @unserialized_#{attr_name} ||= Drupal::Serialize.unserialize(super)
            end
  
            def #{attr_name}=(new_value)
              @unserialized_#{attr_name} = new_value
              super Drupal::Serialize.serialize(new_value)
            end
          EOS
        end
      end
  end
end
