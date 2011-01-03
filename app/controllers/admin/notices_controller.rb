# encoding: utf-8

class Admin::NoticesController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!    
        
  # GET /notices
  # GET /notices.xml
  def index
    @menu = "board"
    @board = "notice"
    @section = "index"
    
    @notices_news = Notice.only_news.search(params[:search], params[:page])
    @notices_notices = Notice.only_notice.search(params[:search], params[:page])    
    @total_count = Notice.only_news.search(params[:search],"").count

    
    render 'notice' 
  end

  # GET /notices/1
  # GET /notices/1.xml
  def show
    @notice = Notice.get(params[:id])
    
    if @notice
      @menu = "board"
      @board = "notice"
      @section = "show"
  
      @notice.hit_cnt += 1
      @notice.save
        
      render 'notice'
    else
      redirect_to '/notices'
    end
  end

  # GET /notices/new
  # GET /notices/new.xml
  def new
    @menu = "board"
    @board = "notice"
    @section = "new"
      
    @notice = Notice.new

    render 'notice'
  end

  # GET /notices/1/edit
  def edit
    @menu = "board"
    @board = "notice"
    @section = "edit"
      
    @notice = Notice.get(params[:id])

    render 'notice'  
  end

  # POST /notices
  # POST /notices.xml
  def create
    @menu = "board"
    @board = "notice"

        
    @notice = Notice.new(params[:notice])
    content = params[:notice][:content]
    # 정규식 처리 
    # content = content.gsub(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix) {|s| s = "<a target='new' href='#{s}'>#{s}</a>"}
    # content = content.gsub(/^https?:\/\/[a-z0-9]+([\.\-\_=&\+\/\?]?[a-z0-9]+)+$/) {|s| s = "<a target='new' href='#{s}'>#{s}</a>"}
    
    # @notice.content = content
    
    urls = content.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    urls.each do |url|
     content.gsub!(url, "<a href='#{url}' target='new'>#{url}</a>")
    end
    
    @notice.content = content
     
    if @notice.save
      redirect_to admin_notices_url
    else
      @section = "new" 
      render 'notice'
    end

  end

  # PUT /notices/1
  # PUT /notices/1.xml
  def update
    @notice = Notice.get(params[:id])
    
    content = params[:notice][:content]
    title = params[:notice][:title]

    # 정규식 처리 
    # urls = content.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    #     urls.each do |url|
    #      content.gsub!(url, "<a href='#{url}'>#{url}</a>")
    #     end
        
    @notice.content = content
    
    @notice.title = title
    if params[:is_notice] == "0"
      @notice.is_notice = false
    else
      @notice.is_notice = true
    end
    
    
    if @notice.save
      redirect_to(@notice)    
    end
  end

  # DELETE /notices/1
  # DELETE /notices/1.xml
  def destroy
    
    @notice = Notice.get(params[:id])
    @notice.destroy

    respond_to do |format|
      format.html { redirect_to(admin_notices_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def deleteSelection 


    chk = params[:chk]
    

    if !chk.nil? 
      chk.each do |chk|
        @notice = Notice.get(chk[0].to_i)
        @notice.destroy    
      end
    else
        flash[:notice] = '삭제할 글을 선택하지 않으셨습니다!'    
    end
      
    redirect_to(admin_notices_url)  
   end
   
end

