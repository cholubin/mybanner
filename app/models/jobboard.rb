# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Jobboard
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :content,      Text,     :lazy => [ :show ]
  property :hit_cnt ,     Integer,  :default => 0
  property :feedback_code, Integer, :default => 0
  property :mytemp_id,    Integer
  timestamps :at
  
  belongs_to :user
    
  def self.search(search, page)
      (Jobboard.all(:title.like => "%#{search}%") | Jobboard.all(:content.like => "%#{search}%")).page :page => page, :per_page => 10
  end
  
end

DataMapper.auto_upgrade!

