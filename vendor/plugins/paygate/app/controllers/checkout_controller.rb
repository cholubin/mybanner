class CheckoutController < ApplicationController     
  
  before_filter :load_paygate_setting
  def ssl_required?
    return false #if local_request? || RAILS_ENV == 'test' || RAILS_ENV == 'development'
    super
  end 

  def request_payment
    redirect_to :action => "process_payment", :name => params[:name], :pay_method => params[:pay_method], :total_price => params[:total_price]
  end
  # create order with pay_method => "mobile" or "card"        
  def process_payment   
    if params != nil     
    @order =Checkout.new(    
    :name => params[:name],
    :pay_method => params[:pay_method] ,
    :total_price => params[:total_price].to_i)
    end     

    if not params[:pay_err]
      render :layout => "paygate"  
    else
     # @err = params[:pay_err].force_encoding('utf-8')
     @error_code = params[:replycode]         
     flash[:error] =  @error_code
     redirect_to pay_url
    end  
  end 

  def pay_result 
    @err = params[:pay_err]
    @result = Checkout.new(    
    :pay_method => params[:paymethod],
    :total_price => params[:unitprice] , 
    :name => params[:goodname],
    :created_at => Time.now,
    :updated_at => Time.now) 

    if @err != "err" && @result.save! 
      flash[:notice] = params[:replycode]    
    else  
                            
      flash[:error] = params[:replycode]
    end
      render :layout => "paygate"             
  end 
  
  private
  def load_paygate_setting 
    @mid = PAYGATE_CONFIG['mid']
    @hosting_url =  PAYGATE_CONFIG['hosting_url']
  end
end
