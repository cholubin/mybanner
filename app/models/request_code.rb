# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Request_code
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource

  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :name,         String 
  property :code,         String
  property :info,         Text
  property :gubun,        String
  timestamps :at

  #   요구사항 코드
  # 0 - 수정요청(처리중) - 맨마지막 글이 수정요청 인 경우 (사용자가 입력하면 게시판에는 자동으로 처리중으로 바뀐다)
  # 1 - 처리완료 - 맨 마지막 글이 관리자의 처리완료 글인 경우
  # 2 - 파일에러 - 맨 마지막 글이 관리자의 파일에러 글인 경우
  # 3 - 보류 - 맨 마지막 글이 사용자 또는 관리자가 보류상태 글 쓴 경우
  # 4 - 선입금대기 - 맨 마지막 글이 관리자의 입금대기 글인 경우
  # 5 - 선입금확인 - 맨마지막 글이 관리자의 입금완료 글인 경우
  
  def self.up
    if Request_code.all().count < 1
      Request_code.new(:code => "0", :name => "수정요청", :info => "맨마지막 글이 수정요청 인 경우", :gubun => "user").save
      Request_code.new(:code => "1", :name => "처리완료", :info => "맨 마지막 글이 관리자의 처리완료 글인 경우", :gubun => "admin").save
      Request_code.new(:code => "2", :name => "파일오류", :info => "맨 마지막 글이 관리자의 파일에러 글인 경우", :gubun => "admin").save
      Request_code.new(:code => "3", :name => "보류", :info => "맨 마지막 글이 사용자 또는 관리자가 보류상태 글 쓴 경우", :gubun => "user,admin").save
      Request_code.new(:code => "4", :name => "선입금대기", :info => "맨 마지막 글이 관리자의 입금대기 글인 경우").save
      Request_code.new(:code => "5", :name => "선입금확인", :info => "맨마지막 글이 관리자의 입금완료 글인 경우").save

    else 
      puts Request_code.first(:priority => 1).id
    end
  end

end

DataMapper.auto_upgrade!