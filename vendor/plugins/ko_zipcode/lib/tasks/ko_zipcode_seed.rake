require 'rubygems'
require 'excelsior'

namespace :ko_zipcode do
  desc "Seed S.Korea zipcode data" 
    task :seed => :environment do    
      
      puts "============================"
      puts "| Started to seed zipcodes |"      
      puts "| Please be patient...     |"  
      # puts "#{File.expand_path(File.dirname(__FILE__))}"
      puts "============================"                                       

      rows = []                                                    
      file_path = Rails.root + "db/raw_zipcode_data/20100721_zipcode_ko_csv.csv"                                           
      
      Excelsior::Reader.rows(File.open(file_path, 'rb')) do   |row|
         rows << row  
      end
      
      rows.count.times do |i|   
        Address.create!(:zipcode => rows[i][0], :city => rows[i][2],
                           :si_goon_goo => rows[i][3], :dong => rows[i][4],  
                           :building => rows[i][12],:address => rows[i][16]) 
                           
      end      
      
      puts "============================"
      puts "| It's done! Happy hacking! |"      
      puts "============================"
  end
end