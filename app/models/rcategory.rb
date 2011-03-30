# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Rcategory
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,               Serial
  property :name,             String, :required => true
  property :priority,         Integer, :default => 9999
  timestamps :at


  def self.up
    if Rcategory.first(:name => '현수막') == nil
      Rcategory.new(:name=>'현수막', :priority=>1).save
      Rcategory.new(:name=>'배너', :priority=>2).save
      Rcategory.new(:name=>'실사출력', :priority=>3).save  
    else 
      puts Rcategory.first(:priority => 1).name
    end
  end
  
end

DataMapper.auto_upgrade!