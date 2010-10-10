# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')                           
Rails::Initializer.run do |config|   
  DM_VERSION    = '~> 0.10.2'   
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'sqlite3-ruby', :lib => 'sqlite3'  
  config.gem 'data_objects',    :version =>  DM_VERSION  
  config.gem 'do_sqlite3',       :version =>     DM_VERSION  
  # config.gem 'do_mysql',       :version =>     DM_VERSION  
  config.gem 'rails_datamapper',  :version =>    DM_VERSION  
  config.gem 'dm-core',              :version =>  DM_VERSION   
  # gem 'dm-core', :git => 'http://github.com/datamapper/dm-core.git'
  config.gem 'dm-migrations',     :version =>     DM_VERSION
  config.gem 'dm-types',          :version =>     DM_VERSION
  config.gem 'dm-validations',    :version =>     DM_VERSION
  config.gem 'dm-constraints',     :version =>    DM_VERSION
  # gem 'dm-transactions',      DM_VERSION
  config.gem 'dm-aggregates',      :version =>    DM_VERSION
  config.gem 'dm-timestamps',      :version =>    DM_VERSION
  config.gem 'dm-observer',        :version =>    DM_VERSION 
  config.gem 'dm-ar-finders',      :version =>    DM_VERSION
  
  config.gem 'excelsior' 
  config.gem 'geokit'
  config.gem 'state_machine', :version => "~>0.9.4"
  
  # config.gem 'factory_girl'
  # config.gem 'test-unit', :version =>   '=1.2.3' , :lib => false
  config.gem "rspec", :lib => false, :version => "~>1.3.0"
  config.gem "rspec-rails", :lib => false, :version => "~>1.3.2"
  # config.gem 'factory_girl', :version => '>=1.3.2', :lib => "factory_girl"
  config.gem 'cucumber', :version =>   '~>0.9.0' , :lib => false
  config.gem 'cucumber-rails', :version =>   '~>0.3.2' , :lib => false 
  config.gem 'database_cleaner', :version => '~>0.5.2' , :lib => false
  config.gem 'webrat', :version => '~>0.7.0' , :lib => false  
  # config.gem 'test-unit', :version => '~>1.2.3' , :lib => false 
  # config.gem 'selenium-client', :version => '0.2.18'
  config.gem 'capybara', :version => ">=0.3.9"
  # config.gem 'culerity'                   
  config.frameworks -= [ :active_record ]    
  config.time_zone = 'UTC'
end    

