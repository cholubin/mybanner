# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Job_code
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :name,         String 
  property :code,         String
  property :info,         Text
  timestamps :at

  #   작업구분코드
  # 0 - 직접편집 - 사용자가 직접편집으로 디자인바구니에 넣은경우
  # 1 - 편집요청 - 사용자가 편집의뢰로 주문하여 디자인바구니에 넣은 경우
  # 2 - 파일접수(차후 추가 예정) - 파일을 직접 접수한경우
  
  def self.up
    if Job_code.all().count < 1
      Job_code.new(:code => "0", :name => "직접편집", :info => "사용자가 직접편집으로 디자인바구니에 넣은경우").save
      Job_code.new(:code => "1", :name => "편집요청", :info => "사용자가 편집의뢰로 주문하여 디자인바구니에 넣은 경우").save
      Job_code.new(:code => "2", :name => "파일접수", :info => "파일을 직접 접수한경우").save

    else 
      puts Job_code.first(:priority => 1).id
    end
  end

end

DataMapper.auto_upgrade!