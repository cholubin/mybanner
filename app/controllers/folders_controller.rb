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
    folder_name = sanitize_filename(params[:folder_name])
    
    folder_count = Folder.all(:user_id => current_user.id, :name => folder_name).count
    total_folder_count = Folder.all(:user_id => current_user.id).count
    if folder_count < 1 and folder_name != "photo"
      if total_folder_count < 12
        @folder = Folder.new()
        @folder.name = folder_name

        @folder.user_id = current_user.id

        if @folder.save
          folder_path =  "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/"+folder_name
          if not File.exist?(folder_path)
            puts %x[ln -s "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/images/photo" "#{folder_path}"]
          end
          
          puts_message folder_name
          render :text => "success" + "/#/" + @folder.id.to_s + "/##/"+ folder_name
        end
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
    
    original_folder_path =  "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/"+@folder.name
    
    rename_folder_name = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/"+sanitize_filename(params[:folder_name])

    @folder.name = sanitize_filename(params[:folder_name])
    
  	if @folder.save
  	  File.rename original_folder_path, rename_folder_name
  	  
  	  @myimages = Myimage.all(:user_id => current_user.id, :folder_id => @folder.id)
  	  @myimages.each do |my|
  	    my.folder_name = @folder.name
  	    my.save
  	  end
  	  render :text => "success"
  	else
  	  render :text => "fail"
    end
    
  end    

  def destroy_folder

    folder_id = params[:folder_id]    
    @folder = Folder.get(folder_id)
    
    if @folder.destroy
      
      folder_path =  "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/"+@folder.name
      if File.exist?(folder_path)
        FileUtils.rm_rf folder_path
      end
      
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

