# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Option
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :name,         String 
  property :priority,     Integer
  property :category_name, String

  timestamps :at
end
