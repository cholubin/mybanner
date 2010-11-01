# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Basicinfo

  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :code,         String
  property :name,         String
  property :info,         Text
  property :category,     String
  property :price,        Integer         
  property :order,        Integer
  timestamps :at

  def self.up
    if Basicinfo.all(:category => "job_request").count < 1
      Basicinfo.new(:code => "0", :name => "직접편집", :category => "job_request", :info => "사용자가 직접편집으로 디자인바구니에 넣은경우", :order => 1).save
      Basicinfo.new(:code => "1", :name => "편집요청", :category => "job_request", :info => "사용자가 편집의뢰로 주문하여 디자인바구니에 넣은 경우", :order => 2).save
      Basicinfo.new(:code => "2", :name => "파일접수", :category => "job_request", :info => "파일을 직접 접수한경우", :order => 3).save
      Basicinfo.new(:code => "3", :name => "시안확정", :category => "job_request", :info => "편집의뢰 후 시안을 확정한 경우", :order => 4).save
    end
    
    if Basicinfo.all(:category => "delivery").count < 1
      Basicinfo.new(:code => "0", :name => "일반택배", :category => "delivery", :price => 3000, :order => 1).save
      Basicinfo.new(:code => "1", :name => "퀵서비스", :category => "delivery", :price => 10000, :order => 2).save
      Basicinfo.new(:code => "2", :name => "직접수령", :category => "delivery", :price => 0, :order => 3).save
    end
    
  end
  
end

# DataMapper.auto_upgrade!