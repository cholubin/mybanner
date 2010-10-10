namespace :paygate do                    
  desc "Datamapper migration"
  task :migrate => :environment do        
    require "dm-migrations/migration_runner"    
    DataMapper::Logger.new(STDOUT, :debug)
    Dir[File.join(Rails.root, "db", "migrate", "create_checkouts.rb")].each{|f| require f}   
    migrate_up!           
  end
end
