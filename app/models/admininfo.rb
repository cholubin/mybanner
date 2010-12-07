# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Admininfo

  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :code,         String
  property :name,         String
  property :content,      Text
  property :info,         Text
  property :file_name,    Text
  property :order,        Integer
  property :category,     String
  timestamps :at

  
  def self.up
    
    # 메인화면  =================================================================================================================
    if Admininfo.all(:category => "main_display").count < 1
      Admininfo.new(:code => "1", :name => "왼쪽", :category => "main_display", :content => "차세대 웹편집솔루션을 소개합니다.", :info => "", :file_name => "a.jpg", :order => 1).save
      Admininfo.new(:code => "2", :name => "가운데", :category => "main_display", :content => "교회 현수막 디자인 다량 추가!", :info => "", :file_name => "b.jpg", :order => 2).save
      Admininfo.new(:code => "3", :name => "오른쪽", :category => "main_display", :content => "시연에 응해주셔서 감사합니다.", :info => "", :file_name => "c.jpg", :order => 3).save
    end
    # 이미지 =================================================================================================================
    if Admininfo.all(:category => "logo").count < 1
      Admininfo.new(:code => "1", :name => "메인로고", :category => "logo", :content => "", :info => "투명 PNG 적용", :order => 1).save
      Admininfo.new(:code => "2", :name => "하단로고", :category => "logo", :content => "", :info => "흰색배경 이미지 적용", :order => 2).save
    end
      
    # 기본정보 ================================================================================================================
    if Admininfo.all(:category => "basic_info").count < 1
      Admininfo.new(:code => "0", :name => "사이트명", :category => "basic_info", :content => "", :info => "타이틀바에 적용", :order => 1).save
      Admininfo.new(:code => "1", :name => "회사명", :category => "basic_info", :content => "", :info => "회사소개, 연락처에서 적용", :order => 2).save
      Admininfo.new(:code => "2", :name => "회사주소", :category => "basic_info", :content => "", :info => "", :order => 3).save
      Admininfo.new(:code => "3", :name => "전화번호", :category => "basic_info", :content => "", :info => "", :order => 4).save
      Admininfo.new(:code => "4", :name => "팩스번호", :category => "basic_info", :content => "", :info => "", :order => 5).save
      Admininfo.new(:code => "5", :name => "사업자등록번호", :category => "basic_info", :content => "", :info => "", :order => 6).save
      Admininfo.new(:code => "6", :name => "통신판매업번호", :category => "basic_info", :content => "", :info => "", :order => 7).save
      Admininfo.new(:code => "7", :name => "대표 이메일주소", :category => "basic_info", :content => "", :info => "", :order => 8).save
      Admininfo.new(:code => "8", :name => "브라우저 검색어", :category => "basic_info", :content => "", :info => "키워드", :order => 9).save
      Admininfo.new(:code => "8", :name => "업무시간", :category => "basic_info", :content => "", :info => "", :order => 10).save
      Admininfo.new(:code => "10", :name => "결제 계좌 은행", :category => "basic_info", :content => "", :info => "", :order => 11).save
      Admininfo.new(:code => "11", :name => "결제 계좌 예금주", :category => "basic_info", :content => "", :info => "", :order => 12).save
      Admininfo.new(:code => "12", :name => "결제계좌 번호", :category => "basic_info", :content => "", :info => "", :order => 13).save
    end
    
    # 약관/개인정보관리책임자 ========================================================================================================
    if Admininfo.all(:category => "agreement").count < 1
      Admininfo.new(:code => "0", :name => "책임자 성명", :category => "agreement", :content => "", :info => "", :order => 1).save
      Admininfo.new(:code => "1", :name => "책임자 직위", :category => "agreement", :content => "", :info => "", :order => 2).save
      Admininfo.new(:code => "2", :name => "책임자 이메일", :category => "agreement", :content => "", :info => "", :order => 3).save
      Admininfo.new(:code => "3", :name => "책임자 전화번호", :category => "agreement", :content => "", :info => "", :order => 4).save
      Admininfo.new(:code => "4", :name => "책임자 팩스번호", :category => "agreement", :content => "", :info => "", :order => 5).save
      Admininfo.new(:code => "5", :name => "개인정보약관 제정일", :category => "agreement", :content => "", :info => "", :order => 6).save
    end
    
    # 결제 설정 ========================================================================================================
    if Admininfo.all(:category => "payment").count < 1
      Admininfo.new(:code => "0", :name => "Paygate 이용여부", :category => "payment", :content => "N", :info => "Y/N", :order => 1).save
      Admininfo.new(:code => "1", :name => "편집의뢰시 선결제 여부", :category => "payment", :content => "N", :info => "Y/N", :order => 2).save
      Admininfo.new(:code => "2", :name => "선결제 금액", :category => "payment", :content => "7000", :info => "", :order => 3).save
    end
  end
  
end

DataMapper.auto_upgrade!