# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Comment
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :content,      Text,     :lazy => [ :show ]
  property :user_id,      Integer
  property :user_name,    String
  property :board,        String
  property :board_id,     Integer
  property :is_admin,     Boolean, :default => false

  timestamps :at
  
end

DataMapper.auto_upgrade!

