# encoding: utf-8

class Admin::AdmininfosController < ApplicationController
  before_filter :authenticate_admin!      

  def skins
    
  end
  
  def session_check
    puts_message "여기 들어오냐?"
    if !admin_signed_in?
      redirect_to '/admin/login'
    else
      render :text => "logined"
    end
  end
  
  def index
    @menu = "admininfo"
    @board = "basicinfo"
    @section = "index"
      
    @basicinfos = Admininfo.all(:category => "basic_info", :order => [:order])
    @agreements = Admininfo.all(:category => "agreement", :order => [:order])
    @payments = Admininfo.all(:category => "payment", :order => [:order])
    @logos = Admininfo.all(:category => "logos", :order => [:order])
    @main_disp = Admininfo.all(:category => "main_display", :order => [:order])
    
    render 'admin/admininfos/admininfo', :layout => false
  end
  
  
  
  def delivery_index
    @menu = "admininfo"
    @board = "delivery"
    @section = "index"
      
    @delivery = Basicinfo.all(:category => "delivery", :order => [:order])
    
    render 'admin/admininfos/admininfo', :layout => false
  end
  
  def save_delivery
    category = params[:category]
  	id = params[:id]
  	price = params[:price].gsub(",","").gsub("원","")
  	gubun = params[:gubun]
  	
  	if id == "" or id == nil
  	  @delivery = Basicinfo.new
  	  max_order = Basicinfo.first(:category => category, :order => [:order.desc]).order + 1
  	  max_code = Basicinfo.first(:category => category, :order => [:order.desc]).code + 1
  	  @delivery.order = max_order
  	  @delivery.code = max_code.to_s
  	  
  	  @delivery.category = category
  	  @delivery.price = price
  	  @delivery.name = gubun
  	  
  	  if @delivery.save
  	    puts_message "배송정보 저장 성공!"
  	    render :text => "success"
  	  else
  	    puts_message "배송정보 저장 실패!"
  	    render :text => "failed"
  	  end
  	  
	  else
	    @delivery = Basicinfo.get(id.to_i)
	    
  	  @delivery.price = price
  	  @delivery.name = gubun
  	  
  	  if @delivery.save
  	    puts_message "배송정보 저장 성공!"
  	    render :text => "success"
  	  else
  	    puts_message "배송정보 저장 실패!"
  	    render :text => "failed"
  	  end
    end
    
  end
  
  def save_deliveries
    category = params[:category]
  	id = params[:ids]
  	price = params[:price]
  	name = params[:name]
  	
  	ids = id.split(",")
  	prices = price.split("$$")
  	names = name.split(",")
  	
  	puts_message "ids::::::::::" + ids.length.to_s
  	i = 0
  	ids.each do |id|
  	  if id != nil and id != "" and id != "##"
  	    delivery = Basicinfo.get(id.to_i)
    	  delivery.name = names[i]
    	  delivery.price = prices[i].gsub(",","").gsub("원","")
    	  
	    else
	      delivery = Basicinfo.new
	      order_max = Basicinfo.all(:category => category).count + 1
	      code_max = order_max.to_s
	      
	      delivery.order = order_max
	      delivery.code = code_max
	      delivery.category = category
	      delivery.name = names[i]
    	  delivery.price = prices[i].gsub(",","").gsub("원","")
    	  
    	  puts_message "여기!!!"
      end
      
      if delivery.save
  	    puts_message "배송정보 저장 성공!"
  	  else
  	    puts_message "배송정보 저장 실패!"
  	  end
  	  
  	  i += 1
  	end
  	
  	@delivery = Basicinfo.all(:category => "delivery", :order => [:order])  
  	
  	render :partial => "delivery_table"
    
  end
  
  
  def save_logo
    id = params[:id].to_i
    name = params[:name]
    
    @info = Admininfo.get(id)
    @info.name = name
    
    if @info.save
      if params[:file] != nil and params[:file] != ""
        
        del_path = "#{RAILS_ROOT}/public/images/admin/main/#{@info.file_name}"
        if File.exists?(del_path)
          FileUtils.remove_entry_secure(del_path)
        end
        
        file = params[:file]
        dir = "#{RAILS_ROOT}/public/images/admin/main/"
        
        FileUtils.mkdir_p dir if not File.exist?(dir)
        LogoUploader.store_dir = dir
        
        uploader = LogoUploader.new
        
        uploader.store!(file)

        file_ext = File.extname(file.original_filename)
        file_name = @info.info
        @info.file_name = file_name + file_ext
        
        if File.exists?(dir + "logo" + file_ext)
          File.rename dir + "logo" + file_ext, dir + @info.file_name
        end
        
        
        if @info.save
          puts_message "로고저장 완료!"
          render :text => "success"
        else
          puts_message "로고저장 실패!"
          render :text => "fail"
        end
      
      else
        puts_message "로고저장 완료!"
        render :text => "success"
      end
      
    else
      render :text => "fail"
    end
    
    
  end


  def save_intro
    
      if params[:file] != nil and params[:file] != ""
        
        begin
          del_path = "#{RAILS_ROOT}/public/images/admin/main/intro.jpg"
          if File.exists?(del_path)
            FileUtils.remove_entry_secure(del_path)
          end
        
          file = params[:file]
          dir = "#{RAILS_ROOT}/public/images/admin/main/"
        
          FileUtils.mkdir_p dir if not File.exist?(dir)
          IntroUploader.store_dir = dir
        
          uploader = IntroUploader.new
        
          uploader.store!(file)

        rescue
          puts_message "로고저장 실패!"
          render :text => "fail"
        end
        
      else
        
        del_path = "#{RAILS_ROOT}/public/images/admin/main/intro.jpg"
        if File.exists?(del_path)
          FileUtils.remove_entry_secure(del_path)
        end
        
        puts_message "로고삭제 완료!"
        render :text => "success"
      end
    
  end
    
  def save_admininfos_main_display
    
    id = params[:id].to_i
    text = params[:text] 
    color = params[:color]

    @info = Admininfo.get(id)
    @info.content = text
    @info.info = color
    
    if @info.save
      if params[:file] != nil and params[:file] != ""
        
        del_path = "#{RAILS_ROOT}/public/images/admin/main/#{@info.file_name}"
        if File.exists?(del_path)
          FileUtils.remove_entry_secure(del_path)
        end
        
        file = params[:file]
        dir = "#{RAILS_ROOT}/public/images/admin/main/"
        puts_message dir
        
        FileUtils.mkdir_p dir if not File.exist?(dir)
        MaindisplayUploader.store_dir = dir
        
        uploader = MaindisplayUploader.new
        
        uploader.store!(file)

        file_ext = File.extname(file.original_filename)
        file_name = @info.id.to_s
        @info.file_name = @info.id.to_s + file_ext
        
        if @info.save
          puts_message "저장완료!"
          render :text => "success"
          
        else
          puts_message "저장실패!"
          render :text => "fail"
        end
      else
        puts_message "저장완료!"
        render :text => "success"
      end
      
    else
      puts_message "저장실패!"
      render :text => "fail"
    end
    
  end
  
  def save_admininfos
     category = params[:category]
     id = params[:ids]
     content = params[:contents]

     @ids_arrary = id.split(",")
     @contents_array = content.split("$$")
     
     begin
       i = 0
       @ids_arrary.each do |k|
         @admininfo = Admininfo.get(k.to_i)
         @admininfo.content = @contents_array[i]
         @admininfo.save
         i += 1
       end
      rescue
        puts_message "관리자 기본정보 저장 실패!"
        render :text => "fail"
      end
       
     puts_message "관리자 기본정보 저장성공!"
     render :text => "success"

   end
  
  
  
  def save_admininfo
     id = params[:id].to_i
     content = params[:content]
     @admininfo = Admininfo.get(id)
     
     @admininfo.content = content
     
     if @admininfo.save
       puts_message "저장완료!"
       render :text => "success"
     else
       puts_message "저장실패!"
       render :text => "failed"
     end
  end
  
  def destroy_delivery
    category = params[:category]
    id = params[:id]
    
    @delivery = Basicinfo.get(id)
    
    if @delivery.destroy
      render :text => "success"
    else
      render :text => "failed"
    end
  end
  
end
