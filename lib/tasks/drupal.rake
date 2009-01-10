namespace :drupal do
  namespace :db do
    namespace :test do
      desc "Empty the drupal test database"
      task :purge => :environment do
        abcs = ActiveRecord::Base.configurations
        ActiveRecord::Base.clear_active_connections!
        drop_database(abcs['drupal_test'])
        create_database(abcs['drupal_test'])
      end

      desc "Prepare the drupal test database"
      task :prepare => "drupal:db:test:purge" do
        Drupal::Base.establish_connection(ActiveRecord::Base.configurations['drupal_test'])
        ActiveRecord::Schema.verbose = false
        Rake::Task["drupal:db:schema:load"].invoke
      end
    end

    namespace :schema do
      desc "Create a db/drupal_schema.rb file that can be portably used against any DB supported by AR"
      task :dump => :environment do
        require 'active_record/schema_dumper'
        File.open(ENV['DRUPAL_SCHEMA'] || "db/drupal_schema.rb", "w") do |file|
          ActiveRecord::SchemaDumper.dump(Drupal::Base.connection, file)
        end
      end
    
      desc "Load a drupal_schema.rb file into the database"
      task :load => :environment do
        ActiveRecord::Base.connection = Drupal::Base.connection
        load(ENV['DRUPAL_SCHEMA'] || "db/drupal_schema.rb")
        ActiveRecord::Base.clear_active_connections!
      end
    end
  end
end
