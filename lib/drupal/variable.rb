module Drupal
  class Variable < Base
    set_table_name "variable"
    set_primary_key "name"
    serializes "value"

    def self.value_of(name)
      if variable = self.find_by_name(name)
        variable.value
      end
    end
  end
end
