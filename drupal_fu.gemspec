Gem::Specification.new do |s|
  s.name     = "drupal_fu"
  s.version  = "1.0.0"
  s.date     = "2009-01-12"
  s.summary  = "Ruby on Rails Models and Helpers for integrating with Drupal."
  s.email    = "simon.harris@cogentconsulting.com.au"
  s.homepage = "http://github.com/harukizaemon/drupal_fu"
  s.description = "Ruby on Rails Models and Helpers for integrating with Drupal."
  s.has_rdoc = true
  s.authors  = ["Simon Harris"]
  s.files    = ["CHANGELOG.rdoc",
                "MIT-LICENSE",
                "README.rdoc",
                "drupal_fu.gemspec",
                "lib/drupal/authmap.rb",
                "lib/drupal/base.rb",
                "lib/drupal/helper.rb",
                "lib/drupal/menu_link.rb",
                "lib/drupal/menu_router.rb",
                "lib/drupal/profile_field.rb",
                "lib/drupal/serialize.rb",
                "lib/drupal/session.rb",
                "lib/drupal/session_store.rb",
                "lib/drupal/url_alias.rb",
                "lib/drupal/user.rb",
                "lib/drupal/variable.rb",
                "lib/drupal_fu.rb",
                "lib/tasks",
                "lib/tasks/drupal.rake"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc"]
end
