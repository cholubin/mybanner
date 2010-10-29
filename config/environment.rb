# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem 'addressable',      :version => '2.1', :lib => 'addressable/uri'

  
  # config.gem "rmagick",           :version => "2.12.2"  
  # config.gem "warden",            :version => ">= 0.10.5"
  # config.gem "devise",            :version => ">= 1.0.7"
  
  # config.gem "rmagick",           :version => ">=2.13.1"    
  config.gem "carrierwave",       :version => ">= 0.4.4"  
  config.gem 'will_paginate',     :version => '2.3.12'
  config.gem 'dm-pager',          :version => '1.1.0'
  config.gem 'do_sqlite3',        :version => '>=0.10.1'
  config.gem 'dm-core',           :version => '0.10.2'
  config.gem 'dm-aggregates',     :version => '0.10.2'
  config.gem 'dm-constraints',    :version => '0.10.2'
  config.gem 'dm-timestamps',     :version => '0.10.2'
  config.gem 'dm-validations',    :version => '0.10.2'
  config.gem 'rails_datamapper',  :version => '0.10.2'
  config.gem 'sanitize',          :version => '>=1.2.0'  
  config.gem "rubyzip",           :lib=>"zip/zip"
  # config.gem "resque",            :version => ">= 1.4.0"
  config.gem "haml", :version => ">=3.0.4"

  config.gem 'excelsior' 
  config.gem 'geokit'
  config.gem 'state_machine', :version => '0.9.4'
  config.gem 'yajl-ruby', :version => '0.7.8', :lib=>"yajl"
    
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.

  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  config.frameworks -= [ :active_record ]  

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

Haml::Template.options[:format] = :html4

  if RAILS_ENV == "production" 
    HOSTING_URL = "http://10.0.1.16:3000/"    
#    HOSTING_URL = "http://211.35.79.132:3000/"
  end
  if RAILS_ENV == "development" 
    HOSTING_URL = "http://localhost:3000/"
  end
  if RAILS_ENV == "test" 
    HOSTING_URL = "http://localhost:3000/"
  end

  # 사용자별 템플릿 공개여부 결정 기능 추가 (for oneplus)
  TEMPLATE_OPEN_FUNC_TOGGLE = false
  
  # if HOSTING_URL == "htt://www.oneplus.asia/"
  #     TEMPLATE_OPEN_FUNC_TOGGLE = true
  # else
  #     TEMPLATE_OPEN_FUNC_TOGGLE = false    
  # end
    
  IMAGE_URL = "#{HOSTING_URL}" + "/user_files/images/"
  IMAGE_PATH = "#{RAILS_ROOT}" + "/public/user_files/images/"
  IMAGE_LOCATION = "/user_files/images/"
  
  # 템플릿 파일들이 위치하는 디렉토리 상수
  TEMP_URL = "#{HOSTING_URL}" + "/templates/"  
  TEMP_PATH = "#{RAILS_ROOT}" + "/public/templates/"



