# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Category
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,               Serial
  property :name,             String, :required => true
  property :rcategory,        String  #대표카테고리 (자동견적의 대표카테고리로 이용)
  property :priority,         Integer, :default => 9999
  # property :sn,           String, :default => "mc"
  property :gubun,            String, :default => "template"
  timestamps :at

  has n, :subcategories

  #   def self.up
  #   if Category.first(:name => '명함') == nil
  #     Category.new(:name=>'명함', :priority=>1).save
  #     Category.new(:name=>'현수막', :priority=>2).save
  #     Category.new(:name=>'봉투', :priority=>3).save  
  #   else 
  #     puts Category.first(:priority => 1).id
  #   end
  # end
end

DataMapper.auto_upgrade!