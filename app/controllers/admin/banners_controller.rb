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
    
    @banner_left = Banner.all(:location => "left", :order => [:order])
    @banner_center = Banner.all(:location => "center", :order => [:order])
    @banner_right = Banner.all(:location => "right", :order => [:order])
    
    render 'banner' 
  end

  def create
    puts_message "create banner start!"
    
    @banner = Banner.new
    
    image_file = params[:image_file]

    if params[:window_mode] == "on"
      @banner.mode = "new"
    else
      @banner.mode = "basic"
    end

    if params[:link_url] == "http://"
      @banner.link_url = ""
    else
      @banner.link_url = params[:link_url]
    end

    @banner.location = params[:location]
    
    order = Banner.all(:location => params[:location]).count + 1
    @banner.order = order
    
    @banner.img_file = params[:image_file]
    
    if @banner.save
      file_name = @banner.id.to_s
      ext_name = File.extname(params[:image_file].original_filename)      
      @banner.img_filename = file_name + ext_name
      @banner.save

      @banner_left = Banner.all(:location => "left")
      @banner_center = Banner.all(:location => "center")
      @banner_right = Banner.all(:location => "right")

    	render :partial => "banner_content"
    else
      puts_message "배너추가 실패!"
      render :text => "error"
    end
    
  end
  
  def delete_banner
    puts_message "delete banner start!"
    id = params[:id].to_i
    
    @banner = Banner.get(id)
    del_dir = "#{RAILS_ROOT}" + "/public/images/admin/banner/"
    filename = @banner.img_filename
    
    puts_message del_dir + filename
    
    if @banner.destroy
      if File.exists?(del_dir + filename)
        FileUtils.rm_rf del_dir + filename
        puts_message filename + " 배너파일 삭제완료!"
      end
      
      @banner_left = Banner.all(:location => "left", :order => [:order])
      @banner_center = Banner.all(:location => "center")
      @banner_right = Banner.all(:location => "right")
      
      i = 1
      @banner_left.each do |l|
        l.order = i
        l.save
        i += 1
      end

      i = 1
      @banner_center.each do |l|
        l.order = i
        l.save
        i += 1
      end
      
      i = 1
      @banner_right.each do |l|
        l.order = i
        l.save
        i += 1
      end
      
    	render :partial => "banner_content"
    	
    else
      puts_message "배너삭제 실패!"
      render :text => "error"
      
    end
    
  end
  
  def banner_order_update
    temp_ids = params[:banner_id]
    banner_ids = temp_ids.split(",")
    
    i = 1
    banner_ids.each do |id|
      @banner = Banner.get(id.to_i)
      @banner.order = i
      i += 1
      @banner.save
    end
    
    render :text => "nothing"
  end
end

