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
  property :id,             Serial
  property :order_no,       String
  property :total_price,    Integer
  property :pre_price,      Integer
  property :left_price,     Integer

  # 주문자 정보 
  property :receive_type,   String
  property :receive_name,   String
  property :receive_note,   Text
  property :pay_method,     String
  property :order_name,     String
  property :order_tel,      String
  property :order_mobile,   String
  property :order_zip,      String
  property :order_addr1,    String
  property :order_addr2,    String
  property :user_id,        Integer
  property :items,          String
  
  timestamps :at

  belongs_to :user
  # has n, :myordersubs
end

DataMapper.auto_upgrade!