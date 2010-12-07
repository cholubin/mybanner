# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-validations'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class User_widthdraw
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  attr_accessor :password
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,                 Serial
  property :userid,             String, :required => true
  property :name,               String, :required => true
  property :email,              String, :required => true
  property :withdrawal_reason,  Text
  timestamps :at
  
  
  def self.search(search, page)
      User_widthdraw.all(:name.like => "%#{search}%").page :page => page, :per_page => 10
  end
  
end

