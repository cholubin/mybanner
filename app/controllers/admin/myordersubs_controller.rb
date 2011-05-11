# encoding: utf-8
class Admin::MyordersubsController < ApplicationController
  layout 'admin_layout'
  before_filter :authenticate_admin!    
  
  def pdf_download
    
    temp_id = params[:temp_id].to_i
    @mytemp = Mytemplate.get(temp_id)
  
    if File.exists?(@mytemp.path + "/web/document.pdf")
      @pdf_path = @mytemp.path + "/web/document.pdf"
    
      @type = "application/pdf"
    
      send_file @pdf_path, :filename => @mytemp.id.to_s + ".pdf" , :type => @type, :stream => "false", :disposition => 'attachment'
    end
    
  end


  def mfile_download
    temp_id = params[:temp_id].to_i
    @mytemp = Mytemplate.get(temp_id)
  
    @zip_path = zip_mfile(@mytemp)
    @type = "application/zip"
    
    send_file @zip_path, :filename => @mytemp.id.to_s + "("+User.get(@mytemp.user_id).userid+")" + ".mlayoutP.zip" , :type => @type, :stream => "false", :disposition => 'attachment'
  end
  
  def zip_mfile(temp)
     @mytemp = temp
     path = "#{RAILS_ROOT}" + "/public/user_files/#{User.get(temp.user_id).userid}/article_templates/"
     zip_name = @mytemp.id.to_s + ".mlayoutP.zip"
     
     puts_message path
     puts_message zip_name
     
     system "cd #{path}; pwd; zip -r #{zip_name} #{@mytemp.id.to_s}.mlayoutP" 
     zip_path = path + zip_name

     return zip_path
   end
   
end
