# encoding: utf-8

class MytemplatesController < ApplicationController
  before_filter :authenticate_user!
  
  
  def index

    #basic_photo 폴더링크가 없으면 생성한다.
    # user_path =  "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/images/basic_photo"
    # if not File.exist?(user_path)
    #   puts %x[ln -s "#{RAILS_ROOT}/public/basic_photo/" "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/images/basic_photo"]
    # end
    
    # Basicinfo.up
        
    @menu = "mytemplate"
    @board = "mytemplate"
    @section = "index"
    
    @category_name = params[:category_name]
    @subcategory_name = params[:subcategory_name]

    cate = params[:cate]
    folder = params[:folder]

    if cate == "all" or cate == nil or cate == ""
      cate = "all"
    end
    if folder == "all" or folder == nil or folder == ""     
      folder = "all"
    end
          
    @categories = Category.all(:order => :priority)        
    

    if cate == "all" and folder == "all"
      @mytemplates = Mytemplate.all(:in_order => false, :user_id => current_user.id, :order => [:created_at.desc]).search(params[:search], params[:page])                   
    elsif cate == "all" and folder != "all"
      @mytemplates = Mytemplate.all(:in_order => false, :folder => Tempfolder.get(folder).name, :user_id => current_user.id, :order => [:created_at.desc]).search(params[:search], params[:page])                                   
    elsif cate != "all" and folder == "all"
      @mytemplates = Mytemplate.all(:in_order => false, :category => cate, :user_id => current_user.id, :order => [:created_at.desc]).search(params[:search], params[:page])                                   
    elsif cate != "all" and folder != "all"
      @mytemplates = Mytemplate.all(:in_order => false, :folder => Tempfolder.get(folder).name, :category => cate, :user_id => current_user.id, :order => [:created_at.desc]).search(params[:search], params[:page])                           
    end
    
    @total_prices = Array.new()
    @mytemplates.each do |my|
      price = total_price_cal_sub(my.id).to_i
      @total_prices << price
    end
    
    # @total_prices.each do |to|
    #   puts_message to.to_s
    # end
    
    @tempfolders = Tempfolder.all(:user_id => current_user.id)
    render 'mytemplate'
  end
  
  def design_confirm
    mytemp_id = params[:mytemp_id].to_i
    has_confirm = params[:has_confirm]
    
    @mytemp = Mytemplate.get(mytemp_id)
    if has_confirm == "y"
      @mytemp.job_status = Basicinfo.first(:category => "job_status", :name => "시안확정").code
      @mytemp.design_confirmed = true
    else
      @mytemp.job_status = Basicinfo.first(:category => "job_status", :name => "시안미확정").code
      @mytemp.design_confirmed = false
    end
    if @mytemp.save
      render :nothing => true
    end
  end

  def create_order
  
  #주문 기본정보 생성
  @myorder = Myorder.new()
  @myorder.receive_type = params[:receive_type]
  @myorder.pay_method = params[:pay_m]
  @myorder.receive_note = params[:receive_note]
  @myorder.total_price = params[:total_price]
  @myorder.receive_name = params[:receive_name]
  @myorder.order_tel = params[:receive_tel]
  @myorder.order_mobile = params[:receive_mobile]
  @myorder.order_zip = params[:zip_code]
  @myorder.order_addr1 = params[:address1]
  @myorder.order_addr2 = params[:address2]
  @myorder.status = 0 #접수완료 코드 (Basicinfo)
  @myorder.user_id = current_user.id
  # @myorder.total_price = params[:total_price].to_i
  
  order_cnt = Myorder.all(:user_id => current_user.id).count + 1
  #주문번호 (월일-사용자별 주문전체횟수 +1) 
  @order_no = Date.today.strftime('%y%m%d') + "-" + order_cnt.to_s
  
  
  @myorder.order_no = @order_no
  
  @myorder.items = params[:ids]
  
  index = 0
  @temp_price = 0
  if params[:direct] == "yes"
    mytemp = Mytemplate.get(@myorder.items.to_i)
    mytemp.in_order = true
    mytemp.job_status = 0
    mytemp.feedback_code = 0
    mytemp.quantity = params[:item_unit].to_i
    @temp_price += (mytemp.quantity * mytemp.price.to_i)
    
    if mytemp.save
      puts_message "주문항목 저장 완료!"
    else
      puts_message "주문항목 저장 실패!"
    end
    
  else
    item_unit = params[:item_unit].split(",")
    
    @myorder.items.split(",").each do |my|
      mytemp = Mytemplate.get(my.to_i)
      mytemp.in_order = true
      mytemp.job_status = 0
      mytemp.feedback_code = 0
      
      mytemp.quantity = item_unit[index].to_i
      @temp_price += (mytemp.quantity * mytemp.price.to_i)
      if mytemp.save
        puts_message "주문항목 저장 완료!"
      else
        puts_message "주문항목 저장 실패!"
      end
      index += 1
    end
    
    @user = User.get(current_user.id)
    
    if @user.tel == nil or @user.tel == ""
      @user.tel = @myorder.order_tel
      @user.mobile = @myorder.order_mobile
      @user.zip = @myorder.order_zip
      @user.addr1 = @myorder.order_addr1
      @user.addr2 = @myorder.order_addr2
      
      if @user.save
        puts_message "사용자 정보 업데이트 성공"
      else
        puts_message "사용자 정보 업데이트 실패!"
      end
    end
    
  end
  

  delivery_price = Basicinfo.first(:category => "delivery", :code => @myorder.receive_type).price
  @myorder.total_price = @temp_price + delivery_price
  begin
    if @myorder.save
      render :text => @order_no
    else
      puts_message @myorder.errors.to_s
      render :text => "주문에러!"
    end
  rescue
    # puts_message @myorder.errors.to_s
    render :text => "주문에러!"
  end
  

  end


  def mytemplate_order

    @menu = "mytemplate"
    @board = "mytemplate"
    @section = "order"
    
    @tempids = params[:ids].split(",")
    @total_price = params[:total_price].gsub(/원/,'').to_i
    @pre_price = 0
      
    render 'mytemplate', :layout => 'ajax-load-page', :object => @tempids, :object => @total_price, :object => @pre_price
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
  
  # GET /mytemplates/1
  # GET /mytemplates/1.xml
  def show
    @menu = "mytemplate"
    @board = "mytemplate"
    @section = "show"
    
    @categories = Category.all(:order => :priority)   
    @mytemplate = Mytemplate.get(params[:id].to_i)

    job_done = @mytemplate.path + "/web/done.txt"
    
    if File.exists?(job_done) then
       FileUtils.remove_entry(job_done)
     end
    
     @reload = params[:reload]
     if @reload == "yes"
       make_contens_xml(@mytemplate)
       erase_job_done_file_temp(@mytemplate)
       fatch_modified_size(@mytemplate)
     end
     
    @category_name = @mytemplate.category
    @subcategory_name = @mytemplate.subcategory
    @total_price = total_price_cal_sub(@mytemplate.id).to_i
    
    render 'mytemplate'    
  end
  
  def fatch_modified_size(temp)
    puts_message "fatch_modified_size Start!"
    
    
    size_file_path = temp.path + "/web/document_size.inf"
    
    begin
      if File.exists?(size_file_path)
        size_file =  File.open(size_file_path, "r")
        if size_file
          size_temp = size_file.sysread(20).gsub(" ","").split(",")
          size_str = size_temp[0] + "cm x " + size_temp[1] + "cm"
          temp.size = size_str
          if temp.save
            puts_message "Size updating success!"
          end
        end
      end
    rescue
      puts_message "Size updating fail!"
    end
  end
  
  def make_contens_xml(temp) 
    
    path = temp.path
    njob = path + "/do_job.mJob"
    mjob_file= <<-EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>WebRootPath</key>
      <string>#{M_ROOT}</string>
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
        system "open -a /Applications/MLayout_#{M_PORT}.app #{mjob}"
      end 
       
    puts_message "make_contens_xml finished"
  end
  
  def erase_job_done_file_temp(temp)        
    job_done = temp.path + "/web/done.txt" 

  
    time_after_4_seconds = Time.now + 4.seconds     
    while Time.now < time_after_4_seconds
      break if File.exists?(job_done)
    end
    
    if !File.exists?(job_done)
      pid = `ps -c -eo pid,comm | grep MLayout_#{M_PORT}`.to_s
      pid = pid.gsub("MLayout_#{M_PORT}",'').gsub(' ', '')
      system "kill #{pid}"     
      puts_message "MLayout was killed!!!!! ============"
    else
      puts_message "There is job done file of PDF file making!"
    end
    
    if File.exists?(job_done)
      FileUtils.remove_entry(job_done)
    end

    puts_message "erase_job_done_file"
   end
   
  # GET /mytemplates/new
  # GET /mytemplates/new.xml
  def new
    @mytemplate = Mytemplate.new
    @categories = Category.all(:order => :priority)    
    @subcategories = Subcategory.all(:order => :priority)
    
     render 'admin/mytemplates/new', :layout => false
  end

  # GET /mytemplates/1/edit
  def edit
    @menu = "mytemplate"
    @board = "mytemplate"
    @section = "edit"


    if Tempfolder.first(:user_id => current_user.id.to_s, :name => "기본") == nil
      @tempfolder = Tempfolder.new()
      @tempfolder.name = "기본"
      @tempfolder.user_id = current_user.id
      @tempfolder.save
    end
            
    @mytemplate = Mytemplate.get(params[:id])
    @tempfolders = Tempfolder.all(:user_id => current_user.id)    
    render 'mytemplate'
  end

  def publish
    @mytemplate = Mytemplate.first(:file_filename => params[:id] + ".mlayoutP.zip", :user_id => current_user.id)   
    erase_job_done_file(@mytemplate)       
    check_job_done_and_publish(@mytemplate) 
    close_document(@mytemplate)  
    erase_job_done_file(@mytemplate)
    move_to_mypdf(@mytemplate)
    redirect_to :action => 'index'
  end

  def erase_job_done_file(mytemplate)         
    puts_message "erase_job_done_file start"
    
    path = mytemplate.path
  
    job_done = path + "/web/done.txt" 
    if File.exists?(job_done)
      FileUtils.remove_entry_secure(job_done)
      puts_message "job done file erased!"              
    end
    puts_message "erase_job_done_file end"      
  end

  def check_job_done_and_publish(mytemplate)
    puts_message "check_job_done_and_publish start"      
    publish_mjob(mytemplate) 
    set_pdf_path(mytemplate)    
    path = mytemplate.path
    # closing a doc right after generating pdf throws mlayout error
    # close_document(mytemplate)
    puts_message "check_job_done_and_publish end"      
  end
    
  def move_to_mypdf(mytemplate)
    puts_message "move_to_mypdf start!"

    mypdf = Mypdf.new
    mypdf.name = mytemplate.name
    mypdf.pdf_filename = mytemplate.file_filename.gsub(/.mlayoutP.zip/,'.pdf')
    mypdf.user_id = current_user.id
    
    
    #중복파일명 처리 
    while File.exist?(mypdf.basic_path + mypdf.pdf_filename) 
      mypdf.pdf_filename = mypdf.pdf_filename.gsub(/.pdf/,'') + "_1" + ".pdf"
    end
    
    source_path = @mytemplate.pdf_path
    destination_dir = mypdf.basic_path + mypdf.pdf_filename
    FileUtils.cp_r source_path, destination_dir
    
    #Thumbnail 생성 
    thumb_image_name = mypdf.pdf_filename.gsub(/.pdf/,'') + "_t" + ".jpg"
    preview_image_name = mypdf.pdf_filename.gsub(/.pdf/,'') + "_p" + ".jpg"
    
	  puts %x[#{RAILS_ROOT}"/lib/thumbup" #{mypdf.basic_path + mypdf.pdf_filename} #{mypdf.basic_path + preview_image_name} 0.5 #{mypdf.basic_path + thumb_image_name} 128]            	      
    
    mypdf.save
    # puts_message @mytemplate.pdf_path
    # puts_message @mytemplate.pdf    
    puts_message "move_to_mypdf end!"    
  end

  
  def copyto_my_template
    @mytemplate = Mytemplate.new
    @mytemplate.user_id = current_user.id  
    @mytemplate.temp_id = params[:temp_id] 
    @mytemplate.save


    copy_template(@mytemplate, @mytemplate.temp_id)    
    # if @mytemplate != nil && @mytemplate.save && @user.save        
    @mytemplate
  
    render :update do |page|
      page.replace_html 'copy_template', :partial => 'copy_template'
    end  
  end  

  # PUT /mytemplates/1
  # PUT /mytemplates/1.xml
  def update
    @mytemplate = Mytemplate.get(params[:id])
    
    @mytemplate.name = params[:mytemplate][:name]
    @mytemplate.folder = params[:mytemplate][:folder]
    @mytemplate.description = params[:mytemplate][:description]
    
    respond_to do |format|
      if @mytemplate.save
        format.html { redirect_to mytemplates_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mytemplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  def jobboard_delete
    bbs_id = params[:bbs_id].to_i
    @bbs = Jobboard.get(bbs_id)
    @mytemp_id = @bbs.mytemp_id
    
    # jobboard req_file 삭제
    req_file_dir = "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/req_files/"
    
    if @bbs.req_file != nil and File.exist?(req_file_dir + @bbs.req_file)
      FileUtils.rm_rf req_file_dir + @bbs.req_file
    end
      
    if @bbs.destroy
      puts_message "요청 게시글 삭제 완료!"
      
      render :partial => 'jbbs_body', :object => @mytemp_id
    else
      puts_message "요청글 게시판 삭제 실패!"
    end
          
  end
  
  def jobboard_create
    mytemp_id = params[:id].to_s
    content = params[:feedback_memo]
    feedback_code = params[:feedback_code].to_i

    bbs = Jobboard.new()
    bbs.user_id = current_user.id
    bbs.content = content
    bbs.feedback_code = feedback_code
    
    @mytemp = Mytemplate.get(mytemp_id.to_i)
    
    if feedback_code != Basicinfo.first(:category => "job_process", :name => "일반글").code
      @mytemp.feedback_code = feedback_code
      @mytemp.save 
    end
    
    
    bbs.mytemp_id = mytemp_id

    if bbs.save
      if params[:feedback_file] != nil and params[:feedback_file] != ""
        req_file = params[:feedback_file]
        #파일업로드
        dir = "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/req_files/"
        FileUtils.mkdir_p dir if not File.exist?(dir)
        ReqfileUploader.store_dir = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/req_files/"

        uploader = ReqfileUploader.new
        
          uploader.store!(req_file)

          file_ext = File.extname(req_file.original_filename)
          file_name = bbs.id.to_s
          bbs.req_file = bbs.id.to_s + file_ext
          bbs.original_filename = req_file.original_filename
          if bbs.save
            puts_message "첨부파일 업로드 완료!"
            puts_message "이미지 하드에도 업로드 진행!"
            
            @myimage = Myimage.new()
            @myimage.user_id = current_user.id
            
            add_myimage(@myimage, params[:feedback_file])
          end
      end
      
      puts_message "요청게시글 등록완료!"
    else
      puts_message "error!"
    end

    @mytemp_id = mytemp_id
    
    render :partial => 'jbbs_body', :object => @mytemp_id
  end    

  def add_myimage(myimage, myimage_image_file)
    @myimage = myimage
    @myimage.user_id = current_user.id
    
    
    @myimage.folder_name = "photo"

    image_path = @myimage.image_path

    @myimage.image_file = myimage_image_file      
    @temp_filename = sanitize_filename(myimage_image_file.original_filename)

    ext_name = File.extname(@temp_filename)      
    @myimage.type = ext_name.gsub(".",'') 
    @myimage.name = myimage_image_file.original_filename.gsub(ext_name,"")
      
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
        puts_message "이미지 하드 저장 완료!"
      else
        puts_message "이미지 하드 저장 실패!"
      end
    end
  end
  
  
  def update_option
    mytemp_id = params[:id].to_i
    @mytemp = Mytemplate.get(mytemp_id)
    
    if params[:option] == ""
      @mytemp.option = nil
    else
      @mytemp.option = params[:option]
    end
    
    if @mytemp.save
      total_price = total_price_cal_sub(mytemp_id).to_i
      render :text => total_price.to_s
    else
      puts_message "옵션을 업데이트 하는 도중 오류가 발생했습니다!"
    end
  end
  
  def update_quantity
    mytemp_id = params[:id].to_i
    quantity= params[:quantity]
    
    @mytemp = Mytemplate.get(mytemp_id)
    @mytemp.quantity = quantity
    if @mytemp.save
      total_price = total_price_cal_sub(mytemp_id).to_i
      render :text => total_price.to_s
    else
      puts_message "수량을 업데이트 하는 도중 오류가 발생했습니다!"
    end
  end
  
  def destroy_order
    order_id = params[:order_id].to_i
    myorder = Myorder.get(order_id)
    myorder.user_del = true
    
    if myorder.save
      mytempid_array = myorder.items.split(",")
      mytempid_array.each do |mytemp_id|
        mytemp = Mytemplate.get(mytemp_id.to_i)
        mytemp.in_order = false
        mytemp.feedback_code = 0
        mytemp.save
      end
      
      render :text => "success"
    else
      puts_message "사용자 주문삭제 실패!"
    end
  end

  def cancel_order
    order_id = params[:order_id].to_i
    myorder = Myorder.get(order_id)

    mytempid_array = myorder.items.split(",")
    mytempid_array.each do |mytemp_id|
      mytemp = Mytemplate.get(mytemp_id.to_i)
      mytemp.in_order = false
      mytemp.feedback_code = 0
      mytemp.design_confirmed = false
      mytemp.save
    end
    
    if myorder.destroy
      render :text => "success"
    else
      puts_message "사용자 주문취소 실패!"
    end
  end
  
  
  def destroy_selection
    @ids = params[:ids].split(",")
    
    @ids.each do |id|
      @mytemplate = Mytemplate.get(id.to_i)
      
        # jobboard req_file 삭제
        req_file_dir = "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/req_files/"
        
        @jobboards = Jobboard.all(:user_id => current_user.id, :mytemp_id => @mytemplate.id)
        
        if @jobboards.count > 0
          @jobboards.each do |j|
            if j.req_file != nil and File.exist?(req_file_dir + j.req_file)
              begin
                FileUtils.rm_rf req_file_dir + j.req_file
              rescue
                puts_message "File Remove Error!"
              end
            end
          end
          
          if @jobboards.destroy
            puts_message "요청게시판 삭제 완료!"
          else
            puts_message "요청게시판 삭제 실패!"
          end
        end
        
        
        if @mytemplate.destroy
          if File.exist?(@mytemplate.path.force_encoding('UTF8-MAC')) 
            begin
              FileUtils.rm_rf @mytemplate.path.force_encoding('UTF8-MAC') 
            rescue
              puts_message "File Remove Error!"
            end
          end
          
          puts_message "마이템플릿 삭제 완료!"
        else
          puts_message "마이템플릿 삭제 실패!!!"
        end
    end
    
    render :nothing => true
    
    end



  def destroy
    mytemplate = Mytemplate.get(params[:id])
    close_document(mytemplate)
    
    begin
      if mytemplate != nil
        if File.exist?(mytemplate.path.force_encoding('UTF8-MAC')) 
          FileUtils.remove_entry_secure mytemplate.path.force_encoding('UTF8-MAC') 
        end
        
        # jobboard req_file 삭제
        req_file_dir = "#{RAILS_ROOT}/public/user_files/#{current_user.userid}/req_files/"
        @jobboards = Jobboard.all(:mytemp_id => mytemplate.id)
        
        if @jobboards.count > 0
          @jobboards.each do |j|
            if j.req_file != nil
              if File.exist?(req_file_dir + j.req_file)
                FileUtils.rm_rf req_file_dir + j.req_file
              end
            end
          end
          
          if @jobboards.destroy
            puts_message "jobboard 삭제완료!"
          end
        end
        
      end
    rescue
      puts_message "Error! in progress of mytemplate file deletion."
    end
    
    mytemplate.destroy
    
    respond_to do |format|
      format.html { redirect_to(mytemplates_url) }
      format.xml  { head :ok }
    end
  end
  
def total_price_cal
  my_id = params[:temp_id].to_i
  total_price = total_price_cal_sub(my_id)
  
  render :text => total_price.to_i.to_s
   
end

def total_price_cal_sub(my_id)
  my = Mytemplate.get(my_id)
  if my.size != nil and my.size != ""
    size_temp = my.size.split(" x ")
  else
    size_temp = [0,0]
  end
  
  size_x = size_temp[0].gsub("cm","")
  size_y = size_temp[1].gsub("cm","")
  
  size = (size_x.to_f * size_y.to_f) / 10000
  ea = my.quantity.to_f
  msg = ea.to_i.to_s + "개 / "
  
  if my.option != nil and my.option != ""
    opt_temp = my.option.split(",")
    opt1_id = opt_temp[0].to_i
    opt2_id = opt_temp[1].to_i

    if Optionsub.get(opt2_id) != nil and Optionsub.get(opt2_id) != ""
      opt2_price = Optionsub.get(opt2_id).price.to_f 
    else
      opt2_price = 0
    end
  else
    opt2_price = 0  
  end
  
  msg = msg + "후가공비: " + opt2_price.to_s
  
  
  # 대표 카테고리 
  rcategory = Category.get(my.category).rcategory
  option_basic = Option_basic.first(:category_name => rcategory)
  
  if option_basic.size_limit_flag == true
    if size < 1.0
      size = 1.0
    end  
  end
  
  msg = msg + " / size: " + size.to_s
  
  unit_price = option_basic.unit_price.to_f
  
  
  # 특정소재나, 후가공을 선택했을 때 기본단가를 변경시킬지 여부 판단 
  if option_basic.unit_price_change_by_meterial_flag == true
    if Optionsub.get(opt1_id) != nil and Optionsub.get(opt1_id) != ""
      unit_price = Optionsub.get(opt1_id).unit_price.to_f
      msg += "/ 소재별 기본단가 변경 적용 "
    end

  elsif option_basic.unit_price_change_by_postproc_flag == true
    if my.option != nil and my.option != "" and Optionsub.get(opt2_id) != nil and Optionsub.get(opt2_id) != ""
      if Optionsub.get(opt2_id).unit_price != nil and Optionsub.get(opt2_id).unit_price != ""
        unit_price = Optionsub.get(opt2_id).unit_price.to_f
        msg += "/ 후가공별 기본단가 변경 적용 "
      end
    end
  end

  msg += "/ 기본단가: " + unit_price.to_s  
  
  # puts_message size.to_s
  # puts_message unit_price.to_s
  # puts_message opt2_price.to_s
  # puts_message ea.to_s
  
  total_price = (((size * unit_price) + opt2_price) * ea) * 1.1
  
  if option_basic.round_off_flag == true
    puts_message "반올림 처리" + "("+option_basic.round_off_unit+") : 원금=>"+ total_price.to_s + "원"
    total_price = round_to(total_price, (option_basic.round_off_unit.to_i == 100)? -3:-4)
  end

  if option_basic.lowest_price_flag == true
    if total_price < option_basic.lowest_price.to_f
      total_price = option_basic.lowest_price.to_f
    end
  end
  
  puts_message msg
  
  return total_price 
end

#반올림 처리 함수 
def round_to(num, decimals)
  factor = 10.0**decimals
  return (num*factor).round / factor
end

    #::PRIVATE METHODS:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    
  private  

    def check_done_txt(mytemplate) 
      path = mytemplate.path
      job_done = path+"/web/done.txt"
      if File.exists?(job_done)
        return true
      else
        return nil
      end
    end



    def check_jpg_and_process_thumbnail(mytemplate)
                            
       tpl = Temp.get(mytemplate.temp_id)  
       job_done = tpl.path + "/web/done.txt"             
       
       puts_message job_done
       loop do 
          break if File.exists?(job_done)
       end   
       process_index_thumbnail(mytemplate)

       # close_document(mytemplate)    
       # erase_job_done_file(mytemplate)   
    end 


    def find_user
      @user = current_user    
    end  

    def delete_template(mytemplate)   
      mytemplate.destroy  
       if mytemplate.path && File.exists?(mytemplate.path) 
          begin
            # FileUtils.remove_entry_secure @temp.path             
            FileUtils.remove_entry mytemplate.path             
          rescue
            flash[:notice] = "failed to delete mytemplate's template"
          end
        end
    end

    def reset_imgs(mytemplate)
      mytemplate.spread_imgs = nil 
      mytemplate.spread_imgs_url = nil  
      mytemplate.spread_mediums.each do |f|      
        FileUtils.remove_entry_secure(f) if File.exist?(f)     
      end   
      mytemplate.spread_mediums = nil
      mytemplate.spread_mediums_url = nil 
      mytemplate.spread_thumbs = nil
      mytemplate.spread_thumbs_url = nil   
    end

    def copy_template(mytemplate, temp_id)  

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

    def generate_xml(mytemplate)   
       # erase_job_done_file(mytemplate)  
      xml_file = <<-EOF
      <xml>
        <title>#{mytemplate.title}</title>
        <subtitle>#{mytemplate.subtitle}</subtitle>
        <lead>#{mytemplate.lead}</lead>
        <author>#{mytemplate.author}</author>
        <body>#{mytemplate.body_html}</body>  
      </xml>
      EOF

      path = mytemplate.path
      write_2_file =  path + "/web/contents.xml"      
      File.open(write_2_file,'w') { |f| f.write xml_file }

      #================


      xml_file= <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>WebRootPath</key>
        <string>#{M_ROOT}</string>
      	<key>Action</key>
      	<string>RefreshXML</string>
      	<key>DocPath</key>
      	<string>#{path}</string>   
        <key>ID</key>
       	<string>#{mytemplate.id}</string>    	
      </dict>
      </plist>

      EOF


       job_to_do = (path + "/refresh_xml_job.mJob")
       File.open(job_to_do,'w') { |f| f.write xml_file }    


       system "open -a /Applications/MLayout_#{M_PORT}.app #{job_to_do}"

      #================

    end 

    
    def close_document(mytemplate)  
      target_template = mytemplate
      path =  target_template.path

      close_xml= <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>WebRootPath</key>
        <string>#{M_ROOT}</string>
      	<key>Action</key>
      	<string>CloseDocument</string>
      	<key>DocPath</key>
      	<string>#{path}</string>
      	<key>ID</key>
       	<string>#{mytemplate.id}</string>
      </dict>
      </plist>

      EOF

      close_job_file = path + "/close_job.mJob"
      
      if File.exist?(path)
        File.open(close_job_file,'w') { |f| f.write close_xml } 
        system "open -a /Applications/MLayout_#{M_PORT}.app #{close_job_file}"
      else
        puts_message "해당 템플릿은 이미 삭제된 상태입니다."
      end
    end


    def publish_mjob(mytemplate)  
 
      puts_message "publish_mjob start"      
      # erase_job_done_file(mytemplate)   
      target_template = mytemplate
      goal = target_template.path    
      puts_message goal
#      goal = mypdf.basic_path    
      
      xml_file = <<-EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>WebRootPath</key>
        <string>#{M_ROOT}</string>
      	<key>Action</key>
      	<string>SaveDocumentPDF</string>
      	<key>DocPath</key>
      	<string>#{goal}</string>   
      	<key>ID</key>
       	<string>#{mytemplate.temp_id}</string>    	
      </dict>
      </plist>

      EOF

      njob = target_template.path + "/publish_job.mJob" 
      File.open(njob,'w') { |f| f.write xml_file }    
      # process_index_thumbnail(target_template.path) 
      system "open -a /Applications/MLayout_#{M_PORT}.app #{njob}"
      

      goal = goal + "/web/document.pdf"

      job_done = target_template.path + "/web/done.txt" 

      # start_file_size = File.size("#{goal}")
      # puts_message "시작시 파일 사이즈!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      # puts_message goal
      # puts_message start_file_size.to_s
      # while Time.now < time_after_180_seconds
      # loop do
      #   time_after_5_seconds = Time.now + 5.seconds             
      #   puts_message time_after_5_seconds.to_s
      #   start_file_size = File.size("#{goal}")
      #   while Time.now < time_after_5_seconds
      #     puts start_file_size.to_s
      #     puts "================"
      #     puts File.size("#{goal}").to_s          
      #   end
      #   break if start_file_size == File.size("#{goal}")
      # end

      puts_message "creating PDF file!!!"
      time_after_180_seconds = Time.now + 180.seconds     
      while Time.now < time_after_180_seconds
        break if File.exists?(job_done)
      end
      
      if !File.exists?(job_done)
        pid = `ps -c -eo pid,comm | grep MLayout_#{M_PORT}`.to_s
        pid = pid.gsub("MLayout_#{M_PORT}",'').gsub(' ', '')
        system "kill #{pid}"     
        puts_message "MLayout was killed!!!!! ============"
      else
        puts_message "There is job done file of PDF file making!"
      end
            
      set_pdf_path(mytemplate)
      puts_message "publish_mjob end"               
    end    

    def set_pdf_path(mytemplate)
      # mypdf = Mypdf.new
      # mypdf.user_id = current_user.id
      #        
      # puts_message mypdf.basic_path
      puts_message "set_pdf_path Start!"
      pdf = "#{RAILS_ROOT}" + "/public/user_files/" + current_user.userid + "/article_templates/" + "#{mytemplate.file_filename.gsub(/.zip/,'')}" +"/web/document.pdf"
      url = "#{HOSTING_URL}" + "/user_files/" + current_user.userid + "/article_templates/" + "#{mytemplate.file_filename.gsub(/.zip/,'')}" +"/web/document.pdf" 
      mytemplate.pdf = url 
      mytemplate.pdf_path = pdf
      if mytemplate.save
        puts_message "pdf_path saved!"
      else
        puts_message "pdf_path save failed!"
      end
      puts_message "set_pdf_path Finished!" 
    end


    #::IMAGE PROCESSING METHODS:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::      

    def process_index_thumbnail(mytemplate) 
      # tmpl = Temp.find_by_mytemplate_id(mytemplate.id) 
      # path = tmpl.path  

      base_dir = "#{RAILS_ROOT}" + "/public/user_files/" + current_user.userid + "/mytemplate_templates/" + "#{mytemplate.id}" +".mlayoutP/web/"
      previews = Dir.new(base_dir).entries.sort.delete_if{|x| !(x =~ /jpg$/)}.delete_if{|x| !(x =~ /spread_preview/)}   
      base_url = "#{HOSTING_URL}" + "/user_files/" + current_user.userid + "/mytemplate_templates/" + "#{mytemplate.id}" + ".mlayoutP/web/"
      index = 1   

      previews.each do |spread|  
        stamp = spread[/\_\d\d\d\d\.jpg/].gsub("_","").gsub(".jpg","")
        source_img = base_dir + spread
        preview_filename = spread
        medium_filename = ("spread_medium_000" + (index).to_s + "_" + stamp + ".jpg")
        thumb_filename = ("spread_thumb_000" + (index).to_s + "_" + stamp +".jpg")

        resize_and_write(source_img, base_dir + medium_filename, "medium")
        # resize_and_write(source_img, base_dir + thumb_filename , "thumb")

        mytemplate.spread_imgs << base_dir + preview_filename
        mytemplate.spread_imgs_url << base_url + preview_filename
        mytemplate.spread_mediums << base_dir + medium_filename
        mytemplate.spread_mediums_url << base_url + medium_filename
        mytemplate.spread_thumbs << base_dir + thumb_filename
        mytemplate.spread_thumbs_url << base_url + thumb_filename 
        index += 1             
      end 
      mytemplate.save 
      return true
    end   

    def resize_and_write(source_img, output, size)
      case size

      when "medium"
        processed_img = Miso::Image.new(source_img) 
        processed_img.crop(280, 124) 
        processed_img.fit(280, 124)
        processed_img.write(output)            
      when "thumb"
        # processed_img = Miso::Image.new(source_img) 
        # processed_img.crop(140, 62) 
        # processed_img.fit(140, 62)
        # processed_img.write(output)      
      else "error"
        # throw error
      end
    end  
    
end
