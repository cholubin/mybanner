# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Optionsub
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,             Serial
  property :name,           Text 
  property :price,          String
  property :info,           Text
  property :priority,       Integer
  
  property :option_id,      Integer
  
  property :category,       Integer
  property :category_name,  String
  property :unit_price,     String
  

  timestamps :at
end
