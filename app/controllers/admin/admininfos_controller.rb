# encoding: utf-8

class Admin::AdmininfosController < ApplicationController
  before_filter :authenticate_admin!      

  def index
    @menu = "admininfo"
    @board = "admininfo"
    @section = "index"
      
    @basicinfos = Admininfo.all(:category => "basic_info", :order => [:order])
    @agreements = Admininfo.all(:category => "agreement", :order => [:order])
    @payments = Admininfo.all(:category => "payment", :order => [:order])
    @logos = Admininfo.all(:category => "logo", :order => [:order])
    
    render 'admin/admininfos/admininfo', :layout => false
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
