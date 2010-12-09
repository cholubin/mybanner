# encoding: utf-8
require 'rexml/document'
include REXML

class PagesController < ApplicationController

  def home
    
    Basicinfo.up
    Admininfo.up
    Request_code.up
    
    @title  = "home"
    @menu = "home"
    
    @categories = Category.all(:order => [ :priority.asc ])
    @mytemplates_namecard_best = Temp.all(:category => "명함").best
    @mytemplates_banner_best = Temp.all(:category => "현수막").best
    @freeboards = Freeboard.all(:limit => 4, :order => :created_at.desc)
    @notices = Notice.all(:limit => 4, :order => :created_at.desc)  
    
    #요청코드 테이블 기본 빌드업. ===================
    #후에 Rake 로 처리 
    if Request_code.all.count < 1
      Request_code.up
    end

    if Job_code.all.count < 1
      Job_code.up
    end
    #=====================================

  end
  
  # 이용안내 페이지 (이용안내는 메인 메뉴로 속함)
  
  def guide
    @title = "동영상 튜토리얼"
    @menu = "guide"
    @section = "home"
  end
  
  # 주문관련 페이지들

  def editorder
  	# 편집의뢰 페이지 ( AJAX 페이지 )
    @title = "편집의뢰"
    render :layout => 'ajax-load-page'
  end

  # 회사소개 페이지들 (회사소개 @menu = "company")

  def about
    @title = "회사소개"
    @menu = "company" 
    @section = "about"
  end
  
  def map
    @title = "연락처/오시는길"
    @menu = "company" 
    @section = "map"
  end
  
  # 고객센터 페이지들 (회사소개 @menu = "cscenter")
  
  def cscenter
  	# 고객센터 기본 화면 (정상혁 추가)
    @title = "고객센터"
    @menu = "cscenter"
    @section = "home"
  end

  def policy
    @title = "개인정보/이용정책 안내"
    @menu = "cscenter"
    @section = "policy"
  end

  def sitemap
    @title = "사이트 맵"
    @menu = "cscenter"
    @section = "sitemap"
  end
 
  # 결과 페이지 ( AJAX로 로딩 )

  def congratulations
    @title = "가입완료"
    # AJAX 팝업을 위한 레이아웃 변경
    render :layout => 'ajax-load-page'
  end
  
  def withdraw
    if signed_in?
      @users = current_user
      @board = "user"
      @section = "withdraw"
      # AJAX 팝업을 위한 레이아웃 변경
      #render 'users/user'
      render :layout => 'ajax-load-page'
    else
      redirect_to '/' 
    end
  end 
  
  def myimage
    if signed_in?
      @users = current_user

      # AJAX 팝업을 위한 레이아웃 변경
      render :layout => 'ajax-load-page'
    else
      redirect_to '/' 
    end
  end 
  
  # 구글 크롬 프레임 추천 페이지
  def recommend_chrome
    @title = "크롬 프레임 추천"
    render :layout => 'ajax-load-page'
  end

  # Web Top Banner에서 사용안하는 페이지
  
  def contact
    @title  = "contact"
    @menu = "contact"
  end

  def tutorial
    @title = "동영상 튜토리얼"
    @menu = "tutorial"
    @categories = Category.all(:order => [:priority])

  end
end
