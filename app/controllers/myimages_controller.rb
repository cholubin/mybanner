# encoding: utf-8

class MyimagesController < ApplicationController
    before_filter :authenticate_user!  
  # GET /myimages
  # GET /myimages.xml
  def get_list
    
    if params[:myimage_folder_id] == "" or params[:myimage_folder_id].nil?
      folder_id = "photo"
    else
      folder_id = params[:myimage_folder_id]
    end
    
    if folder_id == "photo"
      @myimages = Myimage.all(:user_id => current_user.id, :folder_name => folder_id, :order => [:created_at.desc]).search(params[:search],params[:page])
    else
      @myimages = Myimage.all(:user_id => current_user.id, :folder_id => folder_id.to_i, :order => [:created_at.desc]).search(params[:search],params[:page])
    end

    render :partial => 'imagehard_list', :object => @myimages
  end

  def myimage_download
    myimage_id = params[:myimage_id].to_i
    @myimage = Myimage.get(myimage_id)
    if File.exists?("#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/photo/#{@myimage.image_filename}")
      @myimage_path = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/photo/#{@myimage.image_filename}"
      
      if @myimage.type == "pdf"
        @type = "application/" + @myimage.type
      else
        @type = "image/" + @myimage.type
      end
      
      puts_message @myimage.name + "." + @myimage.type
      
      
      send_file @myimage_path, :filename => @myimage.name + "." + @myimage.type, :type => @type, :stream => "false", :disposition =>
      'attachment'
      
    end
    
    
  end
  
  def index
    
    # basic_photo 폴더링크가 없으면 생성한다.
    # user_path =  "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/basic_photo"
    #     if not File.exist?(user_path)
    #       puts %x[ln -s "#{RAILS_ROOT}/public/basic_photo/" "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/images/basic_photo"]
    #     end
    
    #확장자별 소팅
    ext = params[:ext]
    
    @menu = "mytemplate"
    @board = "myimage"
    @section = "index"
  
    if ext == "all" or ext == nil or ext == ""
      ext = "all"
    end
    
    if params[:myimage_folder_id] == "" or params[:myimage_folder_id].nil?
      folder_id = "photo"
      folder_name = "photo"
    else
      folder_id = params[:myimage_folder_id]
      
      if folder_id == "photo"
        folder_name = "photo"
      else
        folder_id = folder_id.to_i
      end
    end
    
    @exts = repository(:default).adapter.select('SELECT distinct type FROM myimages WHERE user_id = '+current_user.id.to_s)
    @myimages = Myimage.all(:user_id => current_user.id, :order => [:created_at.desc]).filter_by(ext, folder_id).search(params[:search], params[:page])
    @folders = Folder.all(:user_id => current_user.id)

    # render 'myimage'
    render 'myimage', :layout => 'ajax-load-page'
    
  end

  # GET /myimages/1
  # GET /myimages/1.xml
  def show_myimage
    if signed_in?
      @menu = "mytemplate"      
      @board = "myimage"
      @section = "show"
      
      @myimage = Myimage.get(params[:id].to_i)
      
      if @myimage.user_id == current_user.id
        render '/myimages/myimage_show', :layout => 'ajax-load-page'
      else
        redirect_to '/'
      end

    else
      redirect_to '/login'
    end
  end

  # GET /myimages/new
  # GET /myimages/new.xml
  def new
    @menu = "mytemplate"    
    @board = "myimage"
    @section = "new"
    
    @myimage = Myimage.new
  
    
    if Folder.first(:user_id => current_user.id.to_s, :name => "photo") == nil
      @folder = Folder.new()
      @folder.name = "photo"
      @folder.user_id = current_user.id
      @folder.save
    end

    @folders = Folder.all(:user_id => current_user.id,:name.not => "basic_photo" )
      
    render 'myimage'
  end

  # GET /myimages/1/edit
  def edit
    @myimage = Myimage.get(params[:id])

    @menu = "mytemplate"    
    @board = "myimage"
    @section = "edit"

    @folders = Folder.all(:user_id => current_user.id)
        
    render 'myimage'    
  end

  # POST /myimages
  # POST /myimages.xml
  def create
    @menu = "mytemplate"    
    @board = "myimage"
    @section = "new"
    
    @myimage = Myimage.new()
    @myimage.user_id = current_user.id
    
    folder_id = params[:myimage_folder_id]
    if folder_id == "photo"
      folder_name = "photo"
      @myimage.folder_name = folder_id
    else
      folder_id = params[:myimage_folder_id].to_i
      folder_name = Folder.get(folder_id.to_i).name
      @myimage.folder_id = folder_id.to_i
      @myimage.folder_name = folder_name
    end
    
    image_path = @myimage.image_path

    # 이미지 업로드 처리 ===============================================================================
    if params[:myimage_image_file] != nil
      
      @myimage.image_file = params[:myimage_image_file]      
      @temp_filename = sanitize_filename(params[:myimage_image_file].original_filename)

      ext_name = File.extname(@temp_filename)      
      @myimage.type = ext_name.gsub(".",'') 
      @myimage.name = params[:myimage_image_file].original_filename.gsub(ext_name,"")
        
      if @myimage.save  
        file_name = @myimage.id.to_s
        @myimage.image_filename = file_name + ext_name

        if ext_name == ".eps" or ext_name == ".pdf"
          @myimage.image_thumb_filename = file_name + ".png"
          puts %x[#{RAILS_ROOT}"/lib/thumbup" #{image_path + "/" + @myimage.image_filename} #{image_path + "/preview/" + file_name + ".png"} 0.5 #{image_path + "/thumb/" + file_name + ".png"} 128]
        else
          @myimage.image_thumb_filename = file_name + ".jpg"
          puts %x[#{RAILS_ROOT}"/lib/thumbup" #{image_path + "/" + @myimage.image_filename} #{image_path + "/preview/" + file_name + ".jpg"} 0.5 #{image_path + "/thumb/" + file_name + ".jpg"} 128]            	  
        end

        if @myimage.save
          render :partial => 'imagehard_partial', :object => @myimage
        end

       else
         puts_message @myimage.errors.to_s
         render :partial => 'imagehard_partial', :object => @myimage
       end

    else
          flash[:notice] = '이미지는 반드시 선택하셔야 합니다.'      
          render 'myimage'
    end
      
      # MyimageUploader.store_dir = @myimage.image_path

  end

  def update_folder
    myimage_id = params[:myimage_id].to_i
    folder_id = params[:folder_id]
    @myimage = Myimage.get(myimage_id)
    
    if folder_id == "photo"
      @myimage.folder_id = nil
      @myimage.folder_name = "photo"
    else
      @myimage.folder_id = folder_id.to_i
      @myimage.folder_name = Folder.get(folder_id).name
    end
    
    if @myimage.save
      render :nothing => true
    end
    
  end
  
  def update_name
    myimage_id = params[:myimage_id].to_i
    myimage_name = params[:filename]
    @myimage = Myimage.get(myimage_id)
    @myimage.name = myimage_name
    
    if @myimage.save
      render :nothing => true
    end
    
  end
  
  def update
    
    #레이아웃 관련 변수 
    @menu = "mytemplate"    
    @board = "myimage"
    @section = "edit"

    #페이징 관련 변수 
    search = params[:search]
    ext = params[:ext]

    #모델관련 변수 
    @myimage = Myimage.get(params[:id])
    @myimage.name = params[:myimage][:name]
    @myimage.description = params[:myimage][:description]
    new_folder_name = params[:myimage][:folder]
    old_folder_name = @myimage.folder
    @myimage.folder = new_folder_name
    
    image_path_basic = @myimage.image_path                          # 기본 이미지폴더 (photo)
    image_path_new_folder = @myimage.image_folder(new_folder_name)  # 변경될 폴더 
    image_path_old_folder = @myimage.image_folder(old_folder_name)  # 기존 폴더     
    
          
    ext_name = File.extname(@myimage.image_filename)
    file_name = @myimage.image_filename.gsub(ext_name,'')

    #파일명의 확장자로 판단하여 타입결정
    @myimage.type = ext_name.gsub('.','')

    #이미지를 변경하는 경우 
    if params[:myimage_image_file] != nil
      #먼저 기존에 업로드된 이미지를 삭제한다.
      if !@myimage.image_path.nil? && !@myimage.image_filename.nil?
        if  File.exist?(image_path_old_folder + "/" + @myimage.image_filename)
          #오리지날 파일 삭제
      	  File.delete(image_path_old_folder + "/" + @myimage.image_filename)         #original image file      
      	  # 썸네일 삭제
      	  if File.exist?(image_path_old_folder + "/thumb/" + @myimage.image_filename)
      	    File.delete(image_path_old_folder + "/thumb/" + @myimage.image_filename)         #original image file
      	  end
      	  # 프리뷰 삭제
      	  if File.exist?(image_path_old_folder + "/preview/" + @myimage.image_filename)
            File.delete(image_path_old_folder + "/preview/" + @myimage.image_filename)   #thumbnail image file  	  
          end
      	end
    	end
    	
    	#새로운 이미지파일을 업로드 한다.
      @myimage.image_file = params[:myimage_image_file]      
      @temp_filename = sanitize_filename(params[:myimage_image_file].original_filename)

      # 중복파일명 처리 ===============================================================================
      # 중복체크는 기본폴더(photo)에서 한 후 목표 폴더로 이동처리 한다. (캐리어웨이브 제약조건 때문.)
      while File.exist?(image_path_basic + "/" + @temp_filename) 
        @temp_filename = @temp_filename.gsub(File.extname(@temp_filename),"") + "_1" + File.extname(@temp_filename)
        @myimage.image_filename = @temp_filename
      end 
      @myimage.image_filename = @temp_filename
      @myimage.image_thumb_filename = @temp_filename
      # 중복파일명 처리 ===============================================================================

      @myimage.image_filename_encoded = @myimage.image_file.filename    	
    end
    
    
    if @myimage.save
      if @temp_filename != nil
        file_name = @myimage.image_filename.gsub(File.extname(@temp_filename),"")
      else
        file_name = @myimage.image_filename.gsub(ext_name,"")        
      end

      #파일을 새롭게 업로드하는 경우 
      if params[:myimage_image_file] != nil
    	  File.rename image_path_basic + "/" + @myimage.image_filename_encoded, image_path_new_folder  + "/" + @myimage.image_filename #original file
    	  #썸네일생성 
    	  puts %x[#{RAILS_ROOT}"/lib/thumbup" #{image_path_new_folder + "/" + @myimage.image_filename} #{image_path_new_folder + "/preview/" + file_name + ".jpg"} 0.5 #{image_path_new_folder + "/thumb/" + file_name + ".jpg"} 128]            	  

      #폴더만 변경하는 경우 
      else
    	  File.rename image_path_old_folder + "/" + @myimage.image_filename, image_path_new_folder  + "/" + @myimage.image_filename #original file
    	  File.rename image_path_old_folder + "/Preview/" + file_name + ".jpg", image_path_new_folder  + "/Preview/" + file_name + ".jpg" #original file
    	  File.rename image_path_old_folder + "/Thumb/" + file_name + ".jpg", image_path_new_folder  + "/Thumb/" + file_name + ".jpg" #original file
      end
  
      redirect_to '/myimages?search='+search+'&ext='+ext
    else
      render 'myimage'
    end


  end

  # DELETE /myimages/1
  # DELETE /myimages/1.xml
  def destroy_myimage
    @myimage = Myimage.get(params[:myimage_id].to_i)
    
    image_path = @myimage.image_folder("photo")
    
    if !image_path.nil? && !@myimage.image_filename.nil?
      if  File.exist?(image_path + "/" + @myimage.image_filename)
        ext_name = File.extname(@myimage.image_filename)
        if ext_name == ".pdf" or ext_name == ".eps"
          thumb_ext_name = ".png"
        else
          thumb_ext_name = ".jpg"
        end
        
        #오리지날 파일 삭제
    	  File.delete(image_path + "/" + @myimage.image_filename)         #original image file      
  	  
    	  # 썸네일 삭제
    	  if File.exist?(image_path + "/Thumb/" + @myimage.image_filename.gsub(ext_name, thumb_ext_name))
    	    File.delete(image_path + "/Thumb/" + @myimage.image_filename.gsub(ext_name, thumb_ext_name))         #original image file
    	  end
    	  # 프리뷰 삭제
    	  if File.exist?(image_path + "/Preview/" + @myimage.image_filename.gsub(ext_name, thumb_ext_name))
          File.delete(image_path + "/Preview/" + @myimage.image_filename.gsub(ext_name, thumb_ext_name))   #thumbnail image file  	  
        end
    	end
  	end
    if @myimage.destroy
      render :text => "success"
    else
      render :text => "fail"
    end
    
  end

end
