# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Option_basic
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,                                 Serial

  property :category_id,                        Integer
  property :category_name,                      String
  property :unit_price,                         Integer
  property :size_limit_flag,                    Boolean
  property :lowest_price_flag,                  Boolean
  property :lowest_price,                       String
  property :unit_price_change_by_postproc_flag, Boolean   #optionsub 테이블 연동
  property :unit_price_change_by_meterial_flag, Boolean   #optionsub 테이블 연동
  
  property :round_off_flag,                     Boolean
  property :round_off_unit,                     String
  
  property :discount_rate_flag,                 Boolean   #discount_rate 테이블과 연동
  
  timestamps :at
end
