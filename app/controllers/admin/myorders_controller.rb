# encoding: utf-8
class Admin::MyordersController < ApplicationController
  layout 'admin_layout'
  before_filter :authenticate_admin!    
  
# GET /mytemplates
# GET /mytemplates.xml
def index

  if params[:stat] == nil or params[:stat] == "" or params[:stat] == "all"
    @status = "all"
    
  else
    @status = params[:stat].to_i
  end
  
  
  @menu = "myorder"
  @board = "myorder"
  @section = "index"
  
  if params[:userid] != nil and params[:userid] != ""
    if @status == "all"
      @myorders = Myorder.all(:user_id => params[:userid].to_i).search(params[:search],params[:page])
      @total_count = @myorders.all(:user_id => params[:userid].to_i).count
    else
      @myorders = Myorder.all(:user_id => params[:userid].to_i, :status => @status).search(params[:search],params[:page])
      @total_count = @myorders.all(:user_id => params[:userid].to_i, :status => @status).count
    end
  else
    if @status == "all"
      @myorders = Myorder.all.search(params[:search],params[:page])
      @total_count = @myorders.count
    else
      @myorders = Myorder.all(:status => @status).search(params[:search],params[:page])
      @total_count = @myorders.all(:status => @status).count
    end
  end
  
  
  
  render 'myorder'
end


def pdf_download
  temp_id = params[:temp_id].to_i
  @mytemp = Mytemplate.get(temp_id)

  if File.exists?(@mytemp.path = "/web/document.pdf")
    @pdf_path = @mytemp.path = "/web/document.pdf"
  
    @type = "application/" + @myimage.type
  
  send_file @pdf_path, :filename => @mytemp.id + "." + @mytemp.type, :type => @type, :stream => "false", :disposition =>
  'attachment'
  
end
  
  
end

def show

  @menu = "myorder"
  @board = "myorder"
  @section = "show"
  
  @myorder = Myorder.get(params[:id])
  
  @reload = params[:reload]
  if @reload == "yes"
    @mytemplate = Mytemplate.get(params[:mytempid].to_i)
    
    job_done = @mytemplate.path + "/web/done.txt" 
    if File.exists?(job_done)
      FileUtils.remove_entry(job_done)
    end
    
    make_contens_xml(@mytemplate)
    erase_job_done_file_temp(@mytemplate)
  end
  
  
  render 'myorder'
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

    time_after_3_seconds = Time.now + 3.seconds     
     while Time.now < time_after_3_seconds
       break if File.exists?(job_done)
     end

     if !File.exists?(job_done)
        pid = `ps -c -eo pid,comm | grep MLayout`.to_s
        pid = pid.gsub(/MLayout 2/,'').gsub(' ', '')
        system "kill #{pid}"     
        puts_message "MLayout was killed!!!!! ============"
      else
        FileUtils.remove_entry(job_done)
        puts_message "There is job done file of PDF file making!"
      end

    puts_message "erase_job_done_file"
 end
 
 
 
 
 
 

def update_status
  
  myorder_id = params[:order_id]
  status_code = params[:status]
  
  @myorder = Myorder.get(myorder_id.to_i)
  @myorder.status = status_code
  
  if @myorder.save
    puts_message "주문정보의 상태가 정상적으로 변경되었습니다."
  else
    puts_message "주문정보의 상태 변경중 오류가 발생했습니다."
    puts_message @myorder.errors.to_s
  end
  
  render :nothing => true
end

def deleteSelection
  @ids = params[:chk]
  
  @ids.each do |id|
    @myorder = Myorder.get(id[0].to_i)
    item_array = @myorder.items.split(",")
    
    item_array.each do |item|
      mytemp = Mytemplate.get(item.to_i)
      mytemp.feedback_code = 0
      mytemp.job_code = 1
      mytemp.option = nil
      # mytemp.size_x = nil
      # mytemp.size_y = nil
      mytemp.quantity = 1
      # mytemp.price = nil
      mytemp.in_order = false
      mytemp.design_confirmed = false
      
      jbbs = Jobboard.all(:mytemp_id => mytemp.id)
      
      if mytemp.save
        jbbs.destroy
      end
    end
    
    @myorder.destroy
    
  end

  redirect_to(admin_myorders_url)
  
  end
  
end
