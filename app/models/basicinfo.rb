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
  property :code,         Integer
  property :name,         String
  property :info,         Text
  property :category,     String
  property :price,        Integer         
  property :order,        Integer
  property :disable,      Boolean, :default => false
  property :is_default,   Boolean, :default => false
  timestamps :at
  
  def self.up
    if Basicinfo.all(:category => "order_process").count < 1
      Basicinfo.new(:code => 0, :name => "접수완료", :category => "order_process", :info => "최초 주문상태", :order => 1).save
      Basicinfo.new(:code => 1, :name => "입금(결제)대기", :category => "order_process", :info => "", :order => 2).save
      Basicinfo.new(:code => 2, :name => "입금(결제)확인", :category => "order_process", :info => "", :order => 3).save
      Basicinfo.new(:code => 3, :name => "제작중", :category => "order_process", :info => "", :order => 4).save
      Basicinfo.new(:code => 4, :name => "제작완료", :category => "order_process", :info => "", :order => 5).save
      Basicinfo.new(:code => 5, :name => "배송중", :category => "order_process", :info => "", :order => 6).save
      Basicinfo.new(:code => 6, :name => "배송완료", :category => "order_process", :info => "", :order => 7).save
    end
    
    if Basicinfo.all(:category => "job_process").count < 1
      Basicinfo.new(:code => 0, :name => "처리중", :category => "job_process", :info => "", :order => 1).save
      Basicinfo.new(:code => 1, :name => "처리완료", :category => "job_process", :info => "", :order => 2).save
      Basicinfo.new(:code => 2, :name => "파일에러", :category => "job_process", :info => "", :order => 3).save
      Basicinfo.new(:code => 3, :name => "보류", :category => "job_process", :info => "", :order => 4).save
      Basicinfo.new(:code => 4, :name => "선입금대기", :category => "job_process", :info => "", :order => 5).save
      Basicinfo.new(:code => 5, :name => "선입금확인", :category => "job_process", :info => "", :order => 6).save
      Basicinfo.new(:code => 6, :name => "일반글", :category => "job_process", :info => "작업과 상관없는 일반적인 내용의 글", :order => 7).save
    end
    
    if Basicinfo.all(:category => "job_status").count < 1  
      Basicinfo.new(:code => 0, :name => "시안미확정", :category => "job_status", :info => "편집의뢰 후 시안을 확정하지 않은 경우", :order => 1).save
      Basicinfo.new(:code => 1, :name => "시안확정", :category => "job_status", :info => "편집의뢰 후 시안을 확정한 경우", :order => 2).save
    end
    
    if Basicinfo.all(:category => "job_request").count < 1
      Basicinfo.new(:code => 0, :name => "직접편집", :category => "job_request", :info => "사용자가 직접편집으로 디자인바구니에 넣은경우", :order => 1).save
      Basicinfo.new(:code => 1, :name => "편집요청", :category => "job_request", :info => "사용자가 편집의뢰로 주문하여 디자인바구니에 넣은 경우", :order => 2).save
      Basicinfo.new(:code => 2, :name => "파일접수", :category => "job_request", :info => "파일을 직접 접수한경우", :order => 3).save
    end
    
    if Basicinfo.all(:category => "delivery").count < 1
      Basicinfo.new(:code => 0, :name => "일반택배", :category => "delivery", :price => 3000, :order => 1).save
      Basicinfo.new(:code => 1, :name => "퀵서비스(착불)", :category => "delivery", :price => 0, :order => 2).save
      Basicinfo.new(:code => 2, :name => "직접수령", :category => "delivery", :price => 0, :order => 3).save
    end
    
    if Basicinfo.all(:category => "pay_method").count < 1
      Basicinfo.new(:code => 0, :name => "직접 계좌이체", :category => "pay_method", :info => "은행계좌로 직접 입금하는 경우", :order => 1, :disable => false, :is_default => true).save
      Basicinfo.new(:code => 1, :name => "실시간 계좌이체", :category => "pay_method", :info => "실시간 계좌이체를 통해 결제하는 경우", :order => 2, :disable => true,).save
      Basicinfo.new(:code => 2, :name => "신용카드", :category => "pay_method", :info => "신용카드로 결제하는 경우", :order => 3, :disable => true).save
      Basicinfo.new(:code => 3, :name => "휴대폰", :category => "pay_method", :info => "휴대폰으로 결제하는 경우", :order => 4, :disable => true).save
    end

    # option, optoinsub 테이블로 처리 
    # if Basicinfo.all(:category => "option1").count < 1
    #   Basicinfo.new(:code => "0", :name => "그래픽천(현수막전용원단)", :category => "option1", :info => "", :order => 1).save
    #   Basicinfo.new(:code => "1", :name => "페트(얇은플라스틱제질원단)", :category => "option1", :info => "", :order => 2).save
    #   Basicinfo.new(:code => "2", :name => "합성지(점착가능원단)", :category => "option1", :info => "", :order => 3).save
    #   Basicinfo.new(:code => "3", :name => "PVC켈(점착가능원단)", :category => "option1", :info => "", :order => 4).save
    #   Basicinfo.new(:code => "4", :name => "부직포(어깨띠전용원단)", :category => "option1", :info => "", :order => 5).save
    #   Basicinfo.new(:code => "5", :name => "폰지(디지털날염전용원단)", :category => "option1", :info => "", :order => 6).save
    # end
    # 
    # if Basicinfo.all(:category => "option2").count < 1
    #   Basicinfo.new(:code => "0", :name => "열재단", :category => "option2", :info => "", :order => 1).save
    #   Basicinfo.new(:code => "1", :name => "사구아일렛", :category => "option2", :info => "", :order => 2).save
    #   Basicinfo.new(:code => "2", :name => "막대가공", :category => "option2", :info => "", :order => 3).save
    #   Basicinfo.new(:code => "3", :name => "봉미싱", :category => "option2", :info => "", :order => 4).save
    #   Basicinfo.new(:code => "4", :name => "끈고리", :category => "option2", :info => "", :order => 5).save
    #   Basicinfo.new(:code => "5", :name => "사방줄미싱", :category => "option2", :info => "", :order => 6).save
    #   Basicinfo.new(:code => "6", :name => "큐방", :category => "option2", :info => "", :order => 7).save
    #   Basicinfo.new(:code => "7", :name => "기타", :category => "option2", :info => "", :order => 8).save
    # end
    
  end
  
end

DataMapper.auto_upgrade!