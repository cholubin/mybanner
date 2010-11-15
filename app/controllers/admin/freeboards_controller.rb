# encoding: utf-8

class Admin::FreeboardsController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!      
  # GET /freeboards
  # GET /freeboards.xml
  def index
    @menu = "board"
    @board = "freeboard"
    @section = "index"
      
    @freeboard = Freeboard.search(params[:search], params[:page])
    @total_count = Freeboard.search(params[:search],"").count
      
    render 'admin/freeboards/freeboard'
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
      
      @comms = Comment.all(:board => "freeboard", :board_id => @freeboard.id)
      
      
      render 'freeboard'
    
    else
      redirect_to '/freeboards'
    end

  end

  def comm_destroy
    comm_id = params[:comm_id].to_i
    
    @comm = Comment.get(comm_id)
    if @comm.destroy
      puts_message "덧글이 성공적으로 삭제되었습니다!"
      render :text => "success!"
    else
      puts_message "덧글의 삭제도중 오류가 발생했습니다!"
      render :text => "failed!"
    end
    
  end
  
  def destroy
    @freeboard = Freeboard.get(params[:id])
    board_id = @freeboard.id
    # session check
    if signed_in? && @freeboard.user_id == current_user.id
      if @freeboard.destroy
        @comments = Comment.all(:board => "freeboard", :board_id => board_id)
        if @comments.count > 0
          @comments.destroy
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to(admin_freeboards_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # multiple deletion
  def deleteSelection 

    chk = params[:chk]

    if !chk.nil? 
      chk.each do |chk|
        @freeboard = Freeboard.get(chk[0].to_i)
        @freeboard.destroy    
      end
    else
        flash[:notice] = '삭제할 글을 선택하지 않으셨습니다!'    
    end
      
    redirect_to(admin_freeboards_url)  
   end
  
end
