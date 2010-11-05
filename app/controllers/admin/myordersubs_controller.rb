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

end
