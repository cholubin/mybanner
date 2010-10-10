# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'dm-core'
require 'rails_datamapper' 
require "dm-migrations/migration_runner"    
Dir[File.join(Rails.root, "db", "migrate", "*")].each{|f| require f}


# Uncomment the next line to use webrat's matchers
# require 'webrat/integrations/rspec-rails'
# require File.dirname(__FILE__) + '/factories'
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
          

Spec::Runner.configure do |config|
  config.mock_with :rspec
  config.before(:all) do   

  end

end
