# desc "Explaining what the task does"
# task :paygate do
#   # Task goes here
# end
                     
namespace :paygate do 
  desc "Setup paygate: migrate db, copy files"
  task :setup do    
 
    system "rsync -ruv vendor/plugins/paygate/config/paygate_setting.yml config"    
    system "rsync -ruv vendor/plugins/paygate/db/migrate db" 
    system "rsync -ruv vendor/plugins/paygate/public/javascripts/translate_codes.js public/javascripts"
    system "rsync -ruv vendor/plugins/paygate/lib/tasks/paygate_migrate.rake lib/tasks" 
    system "rsync -ruv vendor/plugins/paygate/lib/tasks/paygate_setup.rake lib/tasks"                 
  
    system "rake paygate:migrate"     

  end
end