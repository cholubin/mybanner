# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Myorder

  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :order_no,     String
  property :tatal_price,  Integer
  property :pre_price,    Integer
  property :left_price,   Integer

  # 주문자 정보 
  property :order_name,   String
  property :order_tel,     String
  property :order_mobile,  String
  property :order_zip,     String
  property :order_addr1,   String
  property :order_addr2,   String
  
  property :name,         String
  property :user_id,      String
  property :folder_name,  String
  property :order,        Integer,  :default => 1
  timestamps :at

  belongs_to :user
  # has n, :myordersubs
end

DataMapper.auto_upgrade!