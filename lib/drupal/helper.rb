module Drupal
  # Some useful helper methods for accessing various configuration items. Simply include this module in whichever
  # controller(s) need the behaviour. For example:
  #
  #   class ApplicationController < ActionController::Base
  #     include Drupal::Helper
  #     ...
  #   end
  module Helper
    def self.included(base)
      base.send(:helper_method, :primary_links, :root_path, :login_path, :site_name, :site_slogan)
    end

    protected

      def primary_links
        @primary_links ||= menu_links('primary-links')
      end
      
      def root_path
        "/"
      end

      def login_path
        @login_path ||= Drupal::UrlAlias.url_for("/user/login")
      end

      def site_name
        @site_name ||= Drupal::Variable.value_of("site_name")
      end

      def site_slogan
        @site_slogan ||= Drupal::Variable.value_of("site_slogan")
      end

    private

      def menu_links(name)
        Drupal::MenuLink.find(:all,
          :joins => :menu_router,
          :conditions => ["menu_name = ? AND hidden = 0 AND #{Drupal::MenuRouter.table_name}.access_callback <> 'user_is_anonymous'", name],
          :order => "weight",
          :readonly => true)
      end
  end
end
