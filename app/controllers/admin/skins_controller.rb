# encoding: utf-8

class Admin::SkinsController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!    
        
  # GET /notices
  # GET /notices.xml
  def index
    @menu = "admininfo"
    @board = "skins"
    @section = "index"
    
    if Skin.all.count > 0 
      @skin = Skin.first()
    else
      @skin = Skin.new
      @skin.is_custom = false
      @skin.skin_name = "cloud"
      @skin.save
    end
    
    render 'skin' 
  end

  def save_skin
    if params[:skin_type] == "default"
      is_custom = false
      skin_name = params[:skin_css]
      
      @skin = Skin.first()
      
      if params[:chk_bw] == "on"
        @skin.recommend_bw = true
      else
        @skin.recommend_bw = false
      end
      
      @skin.is_custom = is_custom
      @skin.skin_name = skin_name
      if @skin.save
        render :text => "success"
      else
        render :text => "fail"
      end
      
    elsif params[:skin_type] == "custom"
      is_custom = true
      menubar_color = params[:menubar_color]
      background_color = params[:background_color]
      
      @skin = Skin.first()
      
      if params[:chk_bw] == "on"
        @skin.recommend_bw = true
      else
        @skin.recommend_bw = false
      end
      
      @skin.skin_name = "custom"
      @skin.is_custom = is_custom
      @skin.menubar_color = menubar_color
      @skin.background_color = background_color
      
      if @skin.save
        if params[:background_image] != nil and params[:background_image] != ""
          file = params[:background_image]
          
          if File.exists?("#{RAILS_ROOT}" + "/public/images/skin.custom/background.jpg")
            FileUtils.rm_rf "#{RAILS_ROOT}" + "/public/images/skin.custom/background.jpg"
          end
          
          uploader = SkinUploader.new
          uploader.store!(file)
        end
        render :text => "success"
      else
        render :text => "fail"
      end
    end
    
    
  end
end

