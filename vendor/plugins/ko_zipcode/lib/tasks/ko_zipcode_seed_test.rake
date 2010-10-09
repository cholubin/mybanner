namespace :ko_zipcode do                    
  desc "Datamapper test migration"
  task :seed_test_db => :environment do        

    puts "============="
    puts "migrating_up"
    puts "============="
    system "rake environment RAILS_ENV=test dm:migrate"   
    puts "============="
    puts "seeding data"
    puts "============="
    system "rake environment RAILS_ENV=test ko_zipcode:seed"     
    puts "============="
    puts " It's done "
    puts "============="

  end
end
