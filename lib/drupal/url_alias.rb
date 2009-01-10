module Drupal
  class UrlAlias < Base
    set_table_name "url_alias"
    set_primary_key "pid"

    def self.url_for(path, language = "")
      if url_alias = self.find_by_src_and_language(path, language)
        url_alias.dst
      else
        path
      end
    end
  end
end
