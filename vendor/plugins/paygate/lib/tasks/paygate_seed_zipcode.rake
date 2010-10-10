# encoding: utf-8 
require 'rubygems'
require 'excelsior'

namespace :paygate do
  desc "Seed S.Korea zipcode data" 
    task :seed_zipcode => :environment do                                                    
      if Address.all(:dong.like => "%삼성동%") == []
        rows = []                                                    
        file_path = Rails.root + "db/raw_zipcode_data/20100721_zipcode_ko_csv.csv"                                                   

        puts "============================"
        puts "| Started to seed zipcodes |"      
        puts "| Please be patient...     |"  
        puts "============================"
           
        Excelsior::Reader.rows(File.open(file_path, 'rb')) do   |row|
           rows << row  
        end

        rows.count.times do |i|  
          Address.create!(:zipcode => rows[i][0], :city => rows[i][2],
                             :si_goon_goo => rows[i][3], :dong => rows[i][4],  
                             :building => rows[i][12],:address => rows[i][16])   
        end                      
      else
        puts "============================================"
        puts "| It appears you've already seeded zipcodes|"      
        puts "============================================"
      end      
      
       
  end
end