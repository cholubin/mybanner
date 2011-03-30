# encoding: utf-8

class Admin::OptionbasicsController < ApplicationController
  before_filter :authenticate_admin!      

  def index
    @menu = "optionbasic"
    @board = "optionbasic"
    @section = "index"
    if params[:category] == ""
      category = params[:category]
    else
      category = "현수막"
    end
      
    render 'admin/optionbasics/optionbasic', :layout => false
  end

  
  def discount_save
    category_name = params[:category]
    qt = params[:qt].to_i
    condition = params[:condition]
    rate = params[:rate].to_f
    mode = params[:mode]

    
    if Option_basic.all(:category_name => "현수막").count > 0
      @optionbasic = Option_basic.first(:category_name => category_name)
      puts category_name
      puts @optionbasic.id.to_s
    else
      @optionbasic = Option_basic.new()
      @optionbasic.category_name = category_name
      @optionbasic.save
    end
    puts_message @optionbasic.id.to_s
    optionbasic_id = @optionbasic.id
    
    if mode == "new"
      @discount_rate = Discount_rate.new()

      @discount_rate.option_basic_id = optionbasic_id
      @discount_rate.quantity = qt
      @discount_rate.rate = rate
      @discount_rate.condition = condition
      if @discount_rate.save
        puts_message "배율 추가 성공!"
      else
        puts_message "배율 추가 실패!"
      end
    else
      discount_rate_id = params[:rate_id].to_i
      @discount_rate = Discount_rate.get(discount_rate_id)
      @discount_rate.quantity = qt
      @discount_rate.rate = rate
      @discount_rate.condition = condition
      
      if @discount_rate.save
        puts_message "배율 업데이트 성공!"
      else
        puts_message "배율 업데이트 실패!"
      end
    end
    
    @discount_rate = Discount_rate.get(@discount_rate.id)
    puts_message @discount_rate.id.to_s
    
    if mode == "new"
      render :update do |page|
        page.replace_html 'discount_rate_div', :partial => 'discount_rate_div', :object => @discount_rate
      end
    else
      render :text => "success"
    end
    
    # render :nothing => true
  end
  
  def discount_del
    id = params[:id].to_i
    
    discount_rate = Discount_rate.get(id)
    
    if discount_rate.destroy
      render :text => "success"
    else
      render :nothing => true
    end
  end
  
  def option_unit_price_save
    ids = params[:ids].split(",")
    vals = params[:vals].split(",")
    
    i = 0
    ids.each do |id|
       optionsub = Optionsub.get(id.to_i)
       optionsub.unit_price = vals[i]
       optionsub.save
       i += 1
    end
    
    render :text => "success"
  end
  
  def basic_save
    category_id = params[:category_id].to_i
    category_name = params[:category_name]
    bup = params[:bup].to_i
    
    if params[:sl_f] == "true"
      sl_f = true
    else
      sl_f = false
    end
    
    if params[:lp_f] == "true"
      lp_f = true
    else
      lp_f = false
    end
    
    lp = params[:lp]

    if params[:upcbm_f] == "true"
      upcbm_f = true
    else
      upcbm_f = false
    end
    
    if params[:upcbp_f] == "true"
      upcbp_f = true
    else
      upcbp_f = false
    end
        
    if params[:ro_f] == "true"
      ro_f = true
    else
      ro_f = false
    end
    
    ro = params[:ro]

    if params[:dr_f] == "true"
      dr_f = true
    else
      dr_f = false
    end
    
    
    if Option_basic.all(:category_name => category_name).count > 0
      optionbasic = Option_basic.first(:category_name => category_name)
    else
      optionbasic = Option_basic.new()
    end
    
    optionbasic.category_id = category_id
    optionbasic.category_name = category_name
    optionbasic.unit_price = bup
    optionbasic.size_limit_flag = sl_f
    optionbasic.lowest_price_flag = lp_f
    optionbasic.lowest_price = lp
    optionbasic.unit_price_change_by_meterial_flag = upcbm_f
    optionbasic.unit_price_change_by_postproc_flag = upcbp_f
    optionbasic.round_off_flag = ro_f
    optionbasic.round_off_unit = ro
    optionbasic.discount_rate_flag = dr_f
    
    
    # optionbasic.save
    
    if optionbasic.save
      render :text => "success"
    else
      puts_message "저장실패!"
    end

  end
end
