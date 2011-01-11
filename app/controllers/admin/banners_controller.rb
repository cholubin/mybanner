# encoding: utf-8

class Admin::BannersController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!    
        
  # GET /banners
  # GET /banners.xml
  def index
    @menu = "board"
    @board = "banner"
    @section = "index"
    
    @banners = Banner.all
    @total_count = Banner.all

    render 'banner' 
  end

  # GET /banners/1
  # GET /banners/1.xml
  def show
    @banner = Banner.get(params[:id])
    
    if @banner
      @menu = "board"
      @board = "banner"
      @section = "show"
  
      @banner.hit_cnt += 1
      @banner.save
        
      render 'banner'
    else
      redirect_to '/banners'
    end
  end

  # GET /banners/new
  # GET /banners/new.xml
  def new
    @menu = "board"
    @board = "banner"
    @section = "new"
      
    @banner = Banner.new

    render 'banner'
  end

  # GET /banners/1/edit
  def edit
    @menu = "board"
    @board = "banner"
    @section = "edit"
      
    @banner = Banner.get(params[:id])

    render 'banner'  
  end

  # POST /banners
  # POST /banners.xml
  def create
    @menu = "board"
    @board = "banner"

        
    @banner = Banner.new(params[:banner])
    content = params[:banner][:content]
    # 정규식 처리 
    # content = content.gsub(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix) {|s| s = "<a target='new' href='#{s}'>#{s}</a>"}
    # content = content.gsub(/^https?:\/\/[a-z0-9]+([\.\-\_=&\+\/\?]?[a-z0-9]+)+$/) {|s| s = "<a target='new' href='#{s}'>#{s}</a>"}
    
    # @banner.content = content
    
    urls = content.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    urls.each do |url|
     content.gsub!(url, "<a href='#{url}' target='new'>#{url}</a>")
    end
    
    @banner.content = content
     
    if @banner.save
      redirect_to admin_banners_url
    else
      @section = "new" 
      render 'banner'
    end

  end

  # PUT /banners/1
  # PUT /banners/1.xml
  def update
    @banner = Banner.get(params[:id])
    
    content = params[:banner][:content]
    title = params[:banner][:title]

    # 정규식 처리 
    # urls = content.scan(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/ix)
    #     urls.each do |url|
    #      content.gsub!(url, "<a href='#{url}'>#{url}</a>")
    #     end
        
    @banner.content = content
    
    @banner.title = title
    if params[:is_banner] == "0"
      @banner.is_banner = false
    else
      @banner.is_banner = true
    end
    
    
    if @banner.save
      redirect_to(@banner)    
    end
  end

  # DELETE /banners/1
  # DELETE /banners/1.xml
  def destroy
    
    @banner = Banner.get(params[:id])
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to(admin_banners_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def deleteSelection 


    chk = params[:chk]
    

    if !chk.nil? 
      chk.each do |chk|
        @banner = Banner.get(chk[0].to_i)
        @banner.destroy    
      end
    else
        flash[:banner] = '삭제할 글을 선택하지 않으셨습니다!'    
    end
      
    redirect_to(admin_banners_url)  
   end
   
end

