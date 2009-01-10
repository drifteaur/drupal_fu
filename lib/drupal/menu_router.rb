module Drupal
  class MenuRouter < Base
    set_table_name "menu_router"
    set_primary_key "path"
    self.inheritance_column = nil
    serializes "access_arguments", "page_arguments", "title_arguments", "load_functions", "to_arg_functions"
    has_many :menu_links, :foreign_key => "router_path", :class_name => "Drupal::MenuLink"
  end
end
