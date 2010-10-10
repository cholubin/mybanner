# encoding: utf-8

class PagesController < ApplicationController

  def home
    
    #DB가 완전히 초기화 된 상태에서는 /users/new 를 가장 먼저 방문!    
     #Category.up
     #Subcategory.up
    # 
    
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

  def contact
    @title  = "contact"
    @menu = "contact"
  end

  def about
    @title = "about"
    @menu = "about" 
    @categories = Category.all(:order => [:priority])

  end
  
  def tutorial
    @title = "tutorial"
    @menu = "tutorial"
    @categories = Category.all(:order => [:priority])

  end
  
  def test
    @title = "test"
    @menu = "home"
  end
  
 
  def editorder
  	# 편집의뢰 페이지 ( AJAX 페이지 )
    @title = "가입완료"
    @menu = "home"
    render :layout => 'ajax-load-page'
  end
 
  def cscenter
  	# 고객센터 기본 화면 (정상혁 추가)
    @title = "고객센터"
    @menu = "home"
  end

  def congratulations
  	# AJAX 팝업을 위한 레이아웃 변경
    @title = "가입완료"
    @menu = "home"
    render :layout => 'ajax-load-page'
  end
  
  def withdraw
  	# AJAX 팝업을 위한 레이아웃 변경
    if signed_in?
      @users = current_user
      @menu = "home"
      @board = "user"
      @section = "withdraw"
      #render 'users/user'
      render :layout => 'ajax-load-page'
    else
      redirect_to '/' 
    end
  end 
end
