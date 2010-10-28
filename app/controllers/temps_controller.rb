# encoding: utf-8
require 'zip/zip'
require 'zip/zipfilesystem'

class TempsController < ApplicationController
     before_filter :authenticate_user!

     
  # GET /temps
  # GET /temps.xml
  def index
    
    
    if params[:category_name] != nil and params[:category_name] != ""
      @category_name = params[:category_name].to_i
    end
    
    if params[:subcategory_name] != nil and params[:subcategory_name] != ""
      @subcategory_name = params[:subcategory_name].to_i
    end
    
    dir = params[:dir]
    
    if dir.nil?
      is_col = false
    else
      if dir == "col"
        is_col = true
      else
        is_col = false
      end  
    end      
    
    
    # 사용자별 템플릿 공개여부 결정 기능 추가 (for oneplus)
    if TEMPLATE_OPEN_FUNC_TOGGLE == true
      if signed_in?
        if @category_name != nil and @subcategory_name != nil
          @temps = Temp.all(:category => @category_name, :subcategory => @subcategory_name).isopen(current_user.userid).search(params[:search], params[:page])
          @temps_best = Temp.all(:category => @category_name).best
        elsif @category_name != nil
          @temps = Temp.all(:category => @category_name).isopen(current_user.userid).search(params[:search], params[:page])      
          @temps_best = Temp.all(:category => @category_name).best
        elsif  @subcategory_name != nil
          @temps = Temp.all(:subcategory => @subcategory_name).isopen(current_user.userid).search(params[:search], params[:page])      
        else
          @category_name = Category.first(:priority => 1).name
          @temps = Temp.all(:category => @category_name).isopen(current_user.userid).search(params[:search], params[:page])      
          @temps_best = Temp.all(:category => @category_name).best
        end
        @total_count = Temp.search(params[:search],"").isopen(current_user.userid).count    
      else
        @temps = Temp.all(:id => '9999999')
        @total_count = 0
      end
    else
      if @category_name != nil and @subcategory_name != nil
        @temps = Temp.all(:is_col => is_col, :category => @category_name, :subcategory => @subcategory_name).search(params[:search], params[:page])
      elsif @category_name != nil
        @temps = Temp.all(:is_col => is_col, :category => @category_name).search(params[:search], params[:page])      
      elsif  @subcategory_name != nil
        @temps = Temp.all(:is_col => is_col, :subcategory => @subcategory_name).search(params[:search], params[:page])      
      else
        @category_id = Category.first(:priority => 1).id.to_s
        @temps = Temp.all(:is_col => is_col, :category => @category_id).search(params[:search], params[:page])      
      end
      @total_count = Temp.all(:is_col => is_col).search(params[:search],"").count      
    end
    
    
    
    @categories = Category.all(:order => :priority)    
    
    @is_col = is_col
    
    @menu = "template"
    @board = "temp"
    @section = "index"
    
    @category_name = nil
    
    render 'temp'  
  end

  def update_subcategories
      # updates subcategories based on (main)category selected
      
      categories = Category.first(:name => params[:category_id])
      subcategories = categories.subcategories

      # puts subcategories.inspect

      render :update do |page|
        page.replace_html 'subcategories', :partial => 'subcategories', :object => subcategories
      end
  end
  
  # GET /temps/1
  # GET /temps/1.xml
  def show
    @menu = "template"
    @board = "temp"
    @section = "show"
    
    @categories = Category.all(:order => :priority)   
    @temp = Temp.get(params[:id])
    @temp.hit_cnt += 1
    @temp.save
    
    @category_name = @temp.category
    @subcategory_name = @temp.subcategory
    render 'temp'
  end

  # GET /temps/new
  # GET /temps/new.xml
  def new
    @temp = Temp.new
    @categories = Category.all(:order => :priority)    
    @subcategories = Subcategory.all(:order => :priority)
    
     render '/temps/new', :layout => false
  end

  # # GET /temps/1/edit
  # def edit
  #   @temp = Temp.get(params[:id])
  # end

  def create
           
    @temp = Temp.new(params[:temp])
        
    file_path = @temp.file_path

    @temp.file = params[:temp][:file]  if params[:temp][:file]
    @temp.original_filename = params[:temp][:file].original_filename
    @temp.file_filename = sanitize_filename(@temp.original_filename) if params[:temp][:file]
    @temp_filename = @temp.filename
    
    @extname = ".mlayoutP.zip"
    
    while File.exist?(file_path + @temp_filename) 
      @temp_filename = @temp_filename.gsub(@extname,'') + "_1" + @extname
      @temp.file_filename = @temp_filename
    end 
    @temp.file_filename = @temp_filename
    @temp.file_filename_encoded = @temp.file.filename
      
    @temp.zip_file = "#{RAILS_ROOT}/public/templates/" + @temp.file_filename  if params[:temp][:file]
    @temp.path = "#{RAILS_ROOT}" + "/public/templates/" + @temp.file_filename.gsub(/.zip/,'')  if params[:temp][:file]    
    @temp.type = "template"
    
    @temp.thumb_url = "/templates/" + @temp.filename.gsub(/.zip/,'') + "/web/doc_thumb.jpg"         
    @temp.preview_url = "/templates/" + @temp.filename.gsub(/.zip/,'') + "/web/doc_preview.jpg"             
    
        
    respond_to do |format|
      if @temp.save

        # filename renaming ======================================================================
        file_name = @temp.file_filename_encoded
        
        if file_name

         if  File.exist?(file_path + file_name)
          	File.rename file_path + file_name, file_path  + @temp.file_filename #original file
          	@temp.zip_file = file_path  + @temp.file_filename
          end
        end      
        # filename renaming ======================================================================
                
        begin
          unzip_uploaded_file(@temp)
          puts_message "unzip_uploaded_file finished!"
          
          make_contens_xml(@temp) 
          puts_message "make_contens_xml finished!"
          # check_jpg_and_process_thumbnail(@temp) 
             
          # close_document(@temp) 
          # puts_message "close_document finished!"
                    
          erase_job_done_file(@temp)
          puts_message "erase_job_done_file finished!"
                  
          flash[:notice] = 'Temp was successfully created.'
          format.html { redirect_to temps_path }
        rescue
          flash[:notice] = "failed to upload."  
          puts "\n============================== \n error while processing \n ============================== \n"
          redirect_to temps_path          
        end
      else
        format.html { render :action => "new" }
      end
    end
          

  end

  def create_mytemp
    @mytemplate = Mytemplate.new
    @mytemplate.user_id = current_user.id  
    @mytemplate.temp_id = params[:temp_id] 
    @mytemplate.save
        
    edit = params[:edit]

    
    copy_template_mytemp(@mytemplate, @mytemplate.temp_id)    
    # if @mytemplate != nil && @mytemplate.save && @user.save        

    if edit == "req"
      @mytemplate.job_code = 1
      feedback_memo = params[:feedback_memo]
      @mytemplate.size_x = params[:size_info_x]
      @mytemplate.size_y = params[:size_info_y]
      req_file = params[:feedback_file]
      
      if params[:feedback_memo] != "" or params[:feedback_file] != nil
        # jobboard 생성 
        bbs = Jobboard.new()
        bbs.user_id = current_user.id
        bbs.content = feedback_memo
        bbs.feedback_code = 0

        bbs.mytemp_id = @mytemplate.id
        bbs.save
      
        if params[:feedback_file] != nil
          #파일업로드
          dir = "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/req_files/"
          FileUtils.mkdir_p dir if not File.exist?(dir)
          ReqfileUploader.store_dir = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/req_files/"
  
          uploader = ReqfileUploader.new
          # req_file.original_filename = "1.png"
          uploader.store!(req_file)

          file_ext = File.extname(req_file.original_filename)
          file_name = bbs.id.to_s
          bbs.req_file = bbs.id.to_s + file_ext
          bbs.original_filename = req_file.original_filename
          bbs.save
        end
      end
      
    else
      @mytemplate.job_code = 0
    end
    
    if @mytemplate.save              
      begin   
        # 템플릿 복사와 동시에 편집하는 경우
        if edit == "y"
          # @doc_name = @mytemplate.file_filename.gsub(/.zip/,'')
          @doc_name = @mytemplate.id.to_s + ".mlayoutP"       
          @userid = current_user.userid
          @menu = "mlayout"
          
          # render '/cappuccino/show_cappuccino_ui', :layout => 'cappuccino', :popup=>true
          
          @temp_id = @mytemplate.id
          
          
          render :update do |page|
            page.replace_html 'popup_m', :partial => 'popup_m', :object => @temp_id
          end
          
                    
        # 템플릿 복사만 하는 경우
        else
          render :nothing => true
        end

      rescue
        flash[:error] = "Failed to process mlayout"
        render :action => 'index'
      end       
    else 
      flash[:error] = "Failed to create an mytemplate"
      render :action => 'new'
    end
  end
  
  def copy_template_mytemp(mytemplate, temp_id)  

    path = "#{RAILS_ROOT}/public/user_files/" + current_user.userid + "/article_templates"
    
    # 복제될 템플릿 객체 원본
    @object_to_clone = Temp.get(temp_id) 
    
    # 복제된 템플릿 객체
    @cloned_object = mytemplate
    
    @cloned_object.name = @object_to_clone.name
    @cloned_object.price = @object_to_clone.price
    # @cloned_object.file_filename = @object_to_clone.file_filename
    @cloned_object.file_filename = @cloned_object.id.to_s

    @cloned_object.description = @object_to_clone.description
    @cloned_object.temp_id = temp_id 
    @cloned_object.user_id = current_user.id
    mytemplate_filename = @object_to_clone.file_filename.gsub(/.zip/,'')
    mytemplate_new_filename = @cloned_object.id.to_s + ".mlayoutP"

    
    temp_dir = path + "/" + mytemplate_filename      
    new_temp_dir = path + "/" + mytemplate_new_filename

    # while File.exist?(new_temp_dir) 
    #   mytemplate_new_filename = mytemplate_new_filename.gsub(/.mlayoutP/,'') + "_1" + ".mlayoutP"
    #   new_temp_dir = path + "/" + mytemplate_new_filename        
    # end

    @cloned_object.thumb_url = "/user_files/" + current_user.userid + "/article_templates/" +  mytemplate_new_filename + "/web/doc_thumb.jpg"         
    @cloned_object.preview_url = "/user_files/" + current_user.userid + "/article_templates/" + mytemplate_new_filename + "/web/doc_preview.jpg"             

    @cloned_object.category = @object_to_clone.category
    @cloned_object.is_col = @object_to_clone.is_col
    @cloned_object.subcategory = @object_to_clone.subcategory

    @cloned_object.file_filename = mytemplate_new_filename + ".zip"
    @cloned_object.path = "#{RAILS_ROOT}/public/user_files/" + current_user.userid + "/article_templates/" + mytemplate_new_filename
                
    FileUtils.mkdir_p(File.dirname(new_temp_dir))   
          
    source_path = TEMP_PATH + mytemplate_filename
    
    if  RUBY_VERSION != "1.9.2"
      source_path = source_path.force_encoding('UTF8-MAC')
      new_temp_dir = new_temp_dir.force_encoding('UTF8-MAC')
    end
          
    FileUtils.cp_r source_path, new_temp_dir  
    #--- delete template's mjob file     
    tmp = new_temp_dir + "/do_job.mjob"
    FileUtils.remove_entry_secure(tmp) if File.exist?(tmp)
    
    @cloned_object.save
    @object_to_clone.copy_cnt += 1
    @object_to_clone.save
    

  end
  
  def update
    @temp = Temp.get(params[:id])
    
    respond_to do |format|
      if @temp.save
        flash[:notice] = 'Temp was successfully updated.'
        format.html { redirect_to(@temp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /temps/1
  # DELETE /temps/1.xml
  def destroy
    @temp = Temp.get(params[:id])

    

    if @temp != nil
      if File.exist?(TEMP_PATH + @temp.file_filename) 
        File.delete(TEMP_PATH + @temp.file_filename)   
        FileUtils.rm_rf TEMP_PATH + @temp.file_filename.gsub(/.zip/,'')
      end
    end
    
    @temp.destroy

    respond_to do |format|
      format.html { redirect_to(temps_url) }
      format.xml  { head :ok }
    end
  end
  
    def get_img_tags
      @tp = Temp.find_by_id(params[:id])
      @tp.included_images  
      render :json => @tp.included_images
      # render :text => @tp.included_images    
    end 


    private   

    def check_done_txt(temp)
       done_txt = temp.path + "/web/done.txt"

      loop do 
         break if File.exists?(done_txt)

      end    
      
      puts_message "check_done_txt"
      
    end       

    def make_done_txt(temp)
  content= <<-EOF   
  #{temp.id}
  OK   
  EOF

      done_txt_file = (temp.path + "/web/done.txt") 
      File.open(done_txt_file,'w') { |f| f.write content }    
      puts_message "make_done_txt finished"          
    end     

    def check_jpg_and_process_thumbnail(temp)                
       
     check_done_txt(temp) 
     erase_job_done_file(temp)
     # puts "done txt process image"
     process_index_thumbnail(temp)
     # puts "start count image"    
     count_images(temp)      
     # puts "closing your doc"     
      make_done_txt(temp) 

    end

     def close_document(temp)  
       # check_done_txt(temp)  
     erase_job_done_file(temp)     
      close_xml= <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      	<key>Action</key>
      	<string>CloseDocument</string>
      	<key>DocPath</key>
      	<string>#{temp.path}</string> 
        <key>ID</key>
       	<string>#{temp.id}</string>    	         	
      </dict>
      </plist>

      EOF
      close_job_file = (temp.path + "/close_job.mJob") 
      File.open(close_job_file,'w') { |f| f.write close_xml } 
      system "open #{close_job_file}"
    end

     def find_user
       @user = current_user    
     end  

     def erase_job_done_file(temp)        
       job_done = temp.path + "/web/done.txt" 
       if File.exists?(job_done) then
         FileUtils.remove_entry(job_done)
       end
       puts_message "erase_job_done_file"
     end

  
  def unzip_uploaded_file(template) 
   if template != nil   
     destination = TEMP_PATH
     
     loop do 
        break if File.exists?(template.zip_file)
     end
     
     begin              

       unzip(template.zip_file, destination, template.original_filename.gsub(/.zip/,''), template.file_filename.gsub(/.zip/,''))    
       path = TEMP_PATH + template.file_filename.gsub(/.zip/,'')         
       mjob_filename = path + "/do_job.mjob"  
       
       if not File.exists?(mjob_filename)
         # FileUtils.touch(mjob_filename)
         # puts_message "mjob 파일 생성!"
       end         
       
       # osx_tmp_path = ("#{RAILS_ROOT}"+"/public/templates/__MACOSX")
       # if File.exists?(osx_tmp_path)
       #   FileUtils.remove_entry_secure osx_tmp_path
       # end          
      rescue          
       # template.result = "failed"
       puts_error "Template unzip process was failed!"    
      end  
                 
     end
   end  
   
 
   def unzip(file, destination, original_filename, modified_filename)  
     
     begin

       osx_tmp_path = TEMP_PATH + "__MACOSX"
       
       if original_filename != modified_filename
         destination_temp = destination + "temp/"
         renaming_needed = true
       end
              
       Zip::ZipFile.open(file) { |zip_file|
         zip_file.each{ |f| 

           if renaming_needed
              f_path = File.join(destination_temp, f.name)
           else
              f_path = File.join(destination, f.name)
           end

           FileUtils.mkdir_p(File.dirname(f_path))
           zip_file.extract(f, f_path) unless File.exist?(f_path)
         }
       }

       if  renaming_needed && File.exist?(destination_temp + original_filename)
        	File.rename destination_temp + original_filename, destination  + modified_filename
          FileUtils.rm_rf destination_temp
        else
          FileUtils.rm_rf osx_tmp_path
       end
               
     rescue
      puts "An error occurred during unzip process"
     end     
  end
  

  def make_contens_xml(temp) 
    erase_job_done_file(@temp)
    path = temp.path
    njob = path + "/do_job.mJob"
    mjob_file= <<-EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>Action</key>
    	<string>MakeContentsXML</string>
    	<key>DocPath</key>
    	<string>#{path}</string>   
     <key>ID</key>
    	<string>#{temp.id}</string>     	
    </dict>
    </plist>
    </xml>
    EOF
    

     mjob = path + "/do_job.mJob" 
     
 
     
     File.open(mjob,'w') { |f| f.write mjob_file }    

     if File.exists?(mjob)
        system "open #{mjob}"
      end 
          

       
    puts_message "make_contens_xml finished"
  end
  
  def process_index_thumbnail(temp)          

    previews = Dir.new(temp.path  + "/web/").entries.sort.delete_if{|x| !(x =~ /jpg$/)}.delete_if{|x| !(x =~ /spread_preview/)}   

    
    original_image = temp.path  + "/web/" + previews[0] 
    result_image = temp.path  + "/web/jquery_preview.jpg"                     
    
    puts_message original_image
    
    #rvm ruby 1.8.7 - Development environment on jaigouk's local machine
    # @image = Miso::Image.new(original_image)               

    # Native OSX Ruby version includes ruby cocoa
    # @image = Miso::Processor::CoreImage.new(original_image)
    
    # @image.crop(280, 124) #if options[:crop]  
    # @image.fit(280, 124)# if options[:fit]
    # @image.write(result_image)
    temp.spread_preview_url = "#{HOSTING_URL}" + "/user_files/templates/" + @temp.filename + "/web/" + previews[0] 
    temp.save  
    puts_message "process_index_thumbnail finished"   
  end

  def count_images(temp)       
    begin
      doc = File.open(temp.path + "/web/contents.xml")
      xml_doc = Nokogiri::XML(doc)
      array = []
      for n in 1 .. 50
        if xml_doc.search('image_' + n.to_s).count == 1
          array << n
        end
      end 
      temp.included_images = array
      temp.save
      doc.close 
    rescue                       
      flash[:notice] = "failed to read templates' contents file"  
      
    end  
  end
      
  def copy_template
    temp_id = params[:id]                           
    path = "#{RAILS_ROOT}/public/user_files/" + current_user.userid + "/templates"
    @object_to_clone = Temp.get(temp_id) 
    puts @object_to_clone.id
    @cloned_object = Mytemplate.new
    @cloned_object.name = @object_to_clone.name
    @cloned_object.price = @object_to_clone.price
    @cloned_object.file_filename = @object_to_clone.file_filename
    puts @cloned_object.file_filename
    
    @cloned_object.description = @object_to_clone.description
    @cloned_object.temp_id = temp_id 
    @cloned_object.user_id = current_user.id
    mytemplate_filename = @object_to_clone.file_filename.gsub(/.zip/,'')
    
    @cloned_object.thumb_url = "/user_files/" + current_user.userid + "/templates/" +  mytemplate_filename + "/web/doc_thumb.jpg"         
    @cloned_object.preview_url = "/user_files/" + current_user.userid + "/templates/" + mytemplate_filename + "/web/doc_preview.jpg"             
    
    @cloned_object.category = @object_to_clone.category
    @cloned_object.subcategory = @object_to_clone.subcategory
    
    @cloned_object.save
 
    new_temp_dir = path + "/" + mytemplate_filename
    FileUtils.mkdir_p(File.dirname(new_temp_dir))   
    puts_message @object_to_clone.path
    puts_message new_temp_dir
    FileUtils.cp_r TEMP_PATH + mytemplate_filename, new_temp_dir  
    #--- delete template's mjob file     
    tmp = new_temp_dir + "/do_job.mjob"
    FileUtils.remove_entry_secure(tmp) if File.exist?(tmp)  
  end

    
end
