namespace :ko_zipcode do                    
  desc "Datamapper migration"
  task :migrate => :environment do        
    require "dm-migrations/migration_runner"    
    DataMapper::Logger.new(STDOUT, :debug)
    Dir[File.join(Rails.root, "db", "migrate", "create_address.rb")].each{|f| require f}  
    # migrate_down!(100)
    migrate_up! 
  end
end
