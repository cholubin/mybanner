# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Skin
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  # mount_uploader :image_file, SkinUploader
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,               Serial
  property :is_custom,        Boolean
  property :skin_name,        String
  property :menubar_color,    String
  property :background_color, String
  property :image_file,       Text
  property :recommend_bw,     Boolean
  
  #배경이미지는 /public/images/skin.custom.css/background.jpg 로 고정   
  
  timestamps :at
  
end

DataMapper.auto_upgrade!

