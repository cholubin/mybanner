# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Banner
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  mount_uploader :img_file, BannerUploader
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :img_file,     Text 
  property :img_filename, String
  property :mode,         String #기본창:basic, 새창: new
  property :link_url,     Text
  property :location,     String #왼쪽, 가운데, 오른쪽 
  property :order,        Integer
  
  timestamps :at

end

DataMapper.auto_upgrade!