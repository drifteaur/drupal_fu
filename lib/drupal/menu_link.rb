module Drupal
  class MenuLink < Base
    set_primary_key "mlid"
    serializes "options"
    belongs_to :menu_router, :foreign_key => "router_path", :class_name => "Drupal::MenuRouter"

    def title
      link_title
    end
    
    def path
      @path ||= Drupal::UrlAlias.url_for(link_path)
    end
  end
end
