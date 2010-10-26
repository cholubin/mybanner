# encoding: utf-8
class FoldersController < ApplicationController
  before_filter :authenticate_user!    
  # GET /folders
  # GET /folders.xml
  def index
    @folders = Folder.all(:user_id => current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @folders }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    @folder = Folder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    @folder = Folder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @folder = Folder.find(params[:id])
  end

  def update_folder_order
    folder_id = params[:folder_id].split(',')
    
    if !folder_id.nil? 
      i = 1
      folder_id.each do |s|
        folder = Folder.get(s.to_i)
        folder.order = i
        folder.save
        i += 1
      end
    end

    puts_message "folder sorting has finished!"
    render :nothing => true
  end
  
  def create_folder
    folder_name = params[:folder_name]
    
    folder_count = Folder.all(:user_id => current_user.id, :name => folder_name).count
    total_folder_count = Folder.all(:user_id => current_user.id).count
    if folder_count < 1
      if total_folder_count < 12
        @folder = Folder.new()
        @folder.name = folder_name

        @folder.user_id = current_user.id

        @folder.save

        render :text => "success_" + @folder.id.to_s
      else
        render :text => "fail_" + "폴더는 12개 까지만 생성하실 수 있습니다!"
      end
      
    else
      puts_message "이미 생성된 폴더명입니다!"
      render :text => "fail_" + "이미 생성된 폴더명입니다!"
    end

         
  end  

  def update_folder
        
    @folder = Folder.get(params[:folder_id].to_i)
    folder_name = params[:folder_name]    

    @folder.name = folder_name
    
  	if @folder.save
  	  render :text => "success"
  	else
  	  render :text => "fail"
    end
    
  end    

  def destroy_folder

    folder_id = params[:folder_id]    
    @folder = Folder.get(folder_id)
    
    if @folder.destroy
        #이미지 폴더를 기본폴더로 바꾼다.============================================      
    	  @myimages = Myimage.all(:folder_id => @folder.id)
        @img_cnt = @myimages.count
        @myimages.each do |m|
    	    m.folder_id = 9999
    	    m.folder_name = "photo"
        end
        @myimages.save      
        
       render :text => "success"
    else
      render :text => "fail"   
    end

  end
    
end

