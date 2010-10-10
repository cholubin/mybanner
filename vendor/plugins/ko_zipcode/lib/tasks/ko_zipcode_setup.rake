namespace :ko_zipcode do 
  desc "Setup ko_zipcode: migrate, seed and copy files"
  task :setup do    

    system "rsync -ruv vendor/plugins/ko_zipcode/db/migrate db" 
    system "rsync -ruv vendor/plugins/ko_zipcode/db/raw_zipcode_data db"         
    system "rsync -ruv vendor/plugins/ko_zipcode/public ."   
    
    system "rake ko_zipcode:migrate"    
  end
end           
