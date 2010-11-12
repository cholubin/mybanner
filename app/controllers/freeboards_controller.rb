# encoding: utf-8

class FreeboardsController < ApplicationController

  
  # GET /freeboards
  # GET /freeboards.xml
  def index
    @menu = "board"
    @board = "freeboard"
    @section = "index"
    
    @freeboard = Freeboard.search(params[:search], params[:page])
    @total_count = Freeboard.search(params[:search],"").count
    
    render 'freeboard'
  end

  # GET /freeboards/1
  # GET /freeboards/1.xml
  def show
    @freeboard = Freeboard.get(params[:id])
    
    if @freeboard
    
      @freeboard.hit_cnt += 1
      @freeboard.save
    
      @menu = "board"
      @board = "freeboard"
      @section = "show"
      
      @comments = Comment.all(:board => "freeboard", :order => [:updated_at])
      
      render 'freeboard'
    
    else
      redirect_to '/freeboards'
    end

  end

  # GET /freeboards/new
  # GET /freeboards/new.xml
  def new
    
    if signed_in?
      @freeboard = Freeboard.new
      @menu = "board"
      @board = "freeboard"
      @section = "new"  
      flash[:notice] = ""
      render 'freeboard'
    else
      redirect_to '/'
    end
  end

  # GET /freeboards/1/edit
  def edit
    
    @freeboard = Freeboard.get(params[:id])
    
    if signed_in? && current_user.id == @freeboard.user_id
      @menu = "board"
      @board = "freeboard"
      @section = "edit"  
      flash[:notice] = ""
      
      render 'freeboard'    
    else         
      redirect_to '/'
    end
    
  end

  def destroy_comment
    comment_id = params[:comment_id].to_i
    
    @comment = Comment.get(comment_id)
    
    if @comment.user_id == current_user.id
      if @comment.destroy
        render :text => "success!"
      else
        render :text => "failed!"
      end
    
    else
      render :text => "자신의 덧글만 삭제하실 수 있습니다!"
    end
    
    
  end

  def create_comment
    board = params[:board]
    board_id = params[:board_id].to_i
    content = params[:content]
    
    @comment = Comment.new
    @comment.board = board
    @comment.board_id = board_id
    @comment.content = content
    @comment.user_id = current_user.id
    @comment.user_name = User.get(current_user.id).name
    @comment.is_admin = false
    
    if @comment.save
      @comm = @comment
      render :partial => "comment", :object => @comm
    else
      render :text => "failed!" 
    end
    
  end
  
  def create
    @board = "freeboard"
    @section = "new"
    
    @freeboard = Freeboard.new(params[:freeboard])
    @freeboard.user_id = current_user.id
    
    @title = params[:freeboard][:title]
    @content = params[:freeboard][:content]

    if params[:freeboard][:title] == "포스트 제목을 입력하세요 (100글자 이내)" or params[:freeboard][:title].length == 0 or params[:freeboard][:content].length == 0
      flash[:notice] = '제목과 내용을 모두 입력해주세요!'        
      render 'freeboard'      
    elsif params[:freeboard][:title].length > 200
      flash[:notice] = '제목은 100글자 이내로 적어주세요.'  
      render 'freeboard'      
    else
      if @freeboard.save
        redirect_to '/freeboards'
      else
        flash[:notice] = '오류가 발생하였습니다. 다시 시도해 보시거나, 관리자에게 문의해주세요!'
        render 'freeboard'      
      end
    end
  end

  # PUT /freeboards/1
  # PUT /freeboards/1.xml
  def update
    @freeboard = Freeboard.get(params[:id])

    @board = "freeboard"
    @section = "edit"
    
    if params[:freeboard][:title] == "포스트 제목을 입력하세요 (100글자 이내)" or params[:freeboard][:title].length == 0 or params[:freeboard][:content].length == 0
      flash[:notice] = '제목과 내용을 모두 입력해주세요!'        
      render 'freeboard'      
    elsif params[:freeboard][:title].length > 200
      flash[:notice] = '제목은 100글자 이내로 적어주세요.'  
      render 'freeboard'      
    else
      @freeboard.title = params[:freeboard][:title]
      @freeboard.content = params[:freeboard][:content]
      
      if @freeboard.save
        redirect_to '/freeboards'
      else
        flash[:notice] = '오류가 발생하였습니다. 다시 시도해 보시거나, 관리자에게 문의해주세요!'
        render 'freeboard'      
      end
    end
  end

  def destroy_article
    board_id = params[:board_id].to_i
    
    @freeboard = Freeboard.get(board_id)
    
    if @freeboard.user_id == current_user.id
      if @freeboard.destroy
        @comments = Comment.all(:board => "freeboard", :board_id => board_id)
        if @comments.destroy
          render :text => "freeboard article destroy success!"
        end
      else
        render :text => "freeboard article destroy failed!"
      end
      
    else
      render :text => "This article can be deleted only by owner!"
    end
    
  end
  
  def destroy
    @freeboard = Freeboard.get(params[:id])
    
    # session check
    if signed_in? && @freeboard.user_id == current_user.id
      @freeboard.destroy
    end

    respond_to do |format|
      format.html { redirect_to(freeboards_url) }
      format.xml  { head :ok }
    end
  end
end
