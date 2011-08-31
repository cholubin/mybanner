# encoding: utf-8

class SharedimagesController < ApplicationController
    before_filter :authenticate_user!  
  # GET /myimages
  # GET /myimages.xml
  def get_list
    
    @sharedimages = Sharedimage.all(:open_fl => true, :order => [:created_at.desc]).search(params[:search],params[:page])

    render :partial => 'imagehard_list', :object => @sharedimages
  end

  def sharedimage_download
    myimage_id = params[:myimage_id].to_i
    @sharedimage = Sharedimage.get(myimage_id)
    
    if @sharedimage != nil and @sharedimage.open_fl == true and File.exists?("#{RAILS_ROOT}" + "/public/sharedimage/#{@sharedimage.id.to_s}"+"."+"#{@sharedimage.type}")
      @sharedimage_path = "#{RAILS_ROOT}" + "/public/sharedimage/#{@sharedimage.id.to_s}"+"."+"#{@sharedimage.type}"
      
      if @sharedimage.type == "pdf"
        @type = "application/" + @sharedimage.type
      else
        @type = "image/" + @sharedimage.type
      end
      
      puts_message @sharedimage.name + "." + @sharedimage.type
      
      
      send_file @sharedimage_path, :filename => @sharedimage.name + "." + @sharedimage.type, :type => @type, :stream => "false", :disposition =>
      'attachment'
    else
      redirect_to '/'  
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
    
    @exts = repository(:default).adapter.select("SELECT distinct type FROM sharedimages WHERE open_fl = 'true' ")
    @sharedimages = Sharedimage.all(:order => [:created_at.desc],:open_fl => true)
    
    if params[:cat] != "all" and params[:cat] != nil
      @sharedimages = @sharedimages.all(:category => params[:cat].to_i)
    end
    
    if params[:subcat] != "all" and params[:subcat] != nil
      @sharedimages = @sharedimages.all(:subcategory => params[:subcat].to_i)
    end

    @sharedimages = @sharedimages.all.search(@sharedimages, params[:search], params[:page])
    
    
    @folders = Folder.all(:user_id => current_user.id)
    @categories = Category.all(:gubun => "image", :order => :priority)    
    if params[:cat] != "all" and params[:cat] != ""
      @subcategories = Subcategory.all(:category_id => params[:cat])
    else
      @subcategories = Subcategory.all(:category_id => "to_null")
    end
    # render 'sharedimage'
    render 'sharedimage', :layout => 'ajax-load-page'
    
  end
  
  def copy_sharedimage
    folder = params[:folder_id]
    shared_image_id = params[:myimage_id].to_i
    @sharedimage = Sharedimage.get(shared_image_id)
    
    @myimage = Myimage.new()
    if folder != "photo"
      @myimage.folder_id = folder
      @myimage.folder_name = Folder.get(folder.to_i).name
    else
      @myimage.folder_name = "photo"
    end
    @myimage.name = @sharedimage.name
    @myimage.description = @sharedimage.description
    @myimage.tags = @sharedimage.tags
    @myimage.type = @sharedimage.type
    @myimage.user_id = current_user.id

    
    if @myimage.save

      if @sharedimage.type == "eps" or @sharedimage.type == "pdf"
        thumb_type = "png"
      else
        thumb_type = "jpg"
      end
      
      @myimage.image_filename = @myimage.id.to_s + "." + @myimage.type
      @myimage.image_thumb_filename = @myimage.id.to_s + "." + thumb_type
      
      shared_path = "#{RAILS_ROOT}" + "/public/sharedimage/"
      myimage_path = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/#{@myimage.folder_name}/"
      
      @myimage.make_thumb_folder(@myimage.folder_name)
      
      FileUtils.cp_r shared_path + @sharedimage.id.to_s + "." + @sharedimage.type, myimage_path + "#{@myimage.id.to_s}.#{@myimage.type}"
      FileUtils.cp_r shared_path + "Thumb/" + @sharedimage.id.to_s + "." + thumb_type, myimage_path + "Thumb/#{@myimage.id.to_s}.#{thumb_type}"
      FileUtils.cp_r shared_path + "Preview/" + @sharedimage.id.to_s + "." + thumb_type, myimage_path + "Preview/#{@myimage.id.to_s}.#{thumb_type}"
      
      if @myimage.save
        render :text => "success"
      else
        render :text => "DB저장실패!"
      end
    else
      puts_message @myimage.errors.to_s
      render :text => @myimage.errors.to_s
    end
  end
  
  # GET /myimages/1
  # GET /myimages/1.xml
  def show_myimage
    if signed_in?
      @menu = "mytemplate"      
      @board = "myimage"
      @section = "show"
      
      @sharedimage = Sharedimage.get(params[:id].to_i)
      
      render '/sharedimages/myimage_show', :layout => 'ajax-load-page'

    else
      redirect_to '/login'
    end
  end

end
