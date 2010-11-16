# encoding: utf-8

class Admin::AdmininfosController < ApplicationController
  before_filter :authenticate_admin!      

  def index
    @menu = "admininfo"
    @board = "basicinfo"
    @section = "index"
      
    @basicinfos = Admininfo.all(:category => "basic_info", :order => [:order])
    @agreements = Admininfo.all(:category => "agreement", :order => [:order])
    @payments = Admininfo.all(:category => "payment", :order => [:order])
    @logos = Admininfo.all(:category => "logo", :order => [:order])
    
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
  	  max_code = Basicinfo.first(:category => category, :order => [:order.desc]).code.to_i + 1
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
	      order_max = Basicinfo.first(:category => category, :order => [:order.desc]).order + 1
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
  
  def save_admininfos
     category = params[:category]
     id = params[:ids]
     content = params[:contents]

     @ids_arrary = id.split(",")
     @contents_array = content.split("$$")

     i = 0
     @ids_arrary.each do |k|
       @admininfo = Admininfo.get(k.to_i)
       @admininfo.content = @contents_array[i]
       @admininfo.save
       i += 1
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
  
end
