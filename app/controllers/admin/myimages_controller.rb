# encoding: utf-8
class Admin::MyimagesController < ApplicationController
    layout 'admin_layout'
    before_filter :authenticate_admin!    
    
  # GET /myimages
  # GET /myimages.xml
  def index
    @menu = "mytemplate"
    @board = "myimage"
    @section = "index"

      #확장자별 소팅
      if params[:ext] == nil or params[:ext] == "all"
        ext = "all"
      else
        ext = params[:ext]
      end

      if params[:userid] != nil and params[:userid] != ""
        if ext == "all"
          @myimages = Myimage.all(:user_id => params[:userid].to_i).search(params[:search], params[:page])   
          @total_count = Myimage.all(:user_id => params[:userid].to_i).search(params[:search], "").count
        else
          @myimages = Myimage.all(:user_id => params[:userid].to_i, :type => ext, :order => [:created_at.desc]).search(params[:search], params[:page])           
          @total_count = Myimage.all(:user_id => params[:userid].to_i,:type => ext, :order => [:created_at.desc]).search(params[:search], "").count
        end
        
        @exts = repository(:default).adapter.select('SELECT distinct type FROM myimages WHERE user_id = '+ params[:userid])
        
      else
        if ext == "all"
          @myimages = Myimage.all.search(params[:search], params[:page])   
          @total_count = Myimage.all.search(params[:search], "").count
        else
          @myimages = Myimage.all(:type => ext, :order => [:created_at.desc]).search(params[:search], params[:page])           
          @total_count = Myimage.all(:type => ext, :order => [:created_at.desc]).search(params[:search], "").count
        end
        
        @exts = repository(:default).adapter.select('SELECT distinct type FROM myimages')
      end

      render 'myimage'
  end

  def show
      @menu = "user"
      @board = "myimage"
      @section = "show"
        
      @myimage = Myimage.get(params[:id])
      
      render 'myimage'

  end

  # DELETE /myimages/1
  # DELETE /myimages/1.xml
  def destroy
    @myimage = Myimage.get(params[:id])
    
    if  File.exist?(@myimage.image_path + @myimage.image_filename)
  	  File.delete(@myimage.image_path + @myimage.image_filename)         #original image file
      File.delete(@myimage.image_path + @myimage.image_thumb_filename)   #thumbnail image file  	  
  	end
  	
    @myimage.destroy

    respond_to do |format|
      format.html { redirect_to(admin_myimages_url) }
      format.xml  { head :ok }
    end
  end
  
  # multiple deletion
  def deleteSelection 

    chk = params[:chk]

    if !chk.nil? 
      chk.each do |chk|
        @myimage = Myimage.get(chk[0].to_i)
        @myimage.destroy    
      end
    else
        flash[:notice] = '삭제할 글을 선택하지 않으셨습니다!'    
    end
      
    redirect_to(admin_myimages_url)  
   end
     
end
