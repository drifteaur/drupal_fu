module Drupal
  # Base class for all Drupal-specific model classes. If your Rails and Drupal applications share a common database then
  # you can use this class as is. If your Drupal database is seperate, you can do something along the lines of the
  # following in environment.rb:
  #
  #   Drupal::Base.establish_connection "drupal_#{RAILS_ENV}"
  #
  # And add the corresponding entries in database.yml; one for each environment.
  class Base < ActiveRecord::Base
    self.abstract_class = true
    
    protected

      # Convenience method for marking model attributes as serialized. Supports a Ruby-compatible subset of the PHP
      # serialisation mechanism.
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
