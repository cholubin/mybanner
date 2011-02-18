# encoding: utf-8

class Admin::OptionsController < ApplicationController
  before_filter :authenticate_admin!      
  # GET /admin_options
  # GET /admin_options.xml
  def index
    @menu = "option"
    @board = "option"
    @section = "index"
    if params[:category] == ""
      category = params[:category]
    else
      category = "현수막"
    end
      
    @options = Option.all(:order => [ :priority])
    # @discount_rate = Discount_rate.all(:option_basic_id => Option_basic.first(:category_name => category).id)
    
    render 'admin/options/option', :layout => false
  end
  


  # GET /admin_options/1
  # GET /admin_options/1.xml
  def show
    @menu = "option"
    @board = "option"
    @section = "show"
        
    @option = Option.get(params[:id])
    @optionsubs = @option.optionsubs.all(:order => [ :priority.asc ])
    
     render 'admin/options/option', :layout => false
  end

  # GET /admin_options/new
  # GET /admin_options/new.xml
  def new
    @menu = "option"
    @board = "option"
    @section = "new"
      
    @option = Option.new
    @select_main_option = Option.all(:order => [ :priority.asc ])  

     render 'admin/options/option'
  end

  # GET /admin_options/1/edit
  def edit
    
    @menu = "option"
    @board = "option"
    @section = "edit"
        
    @option = Option.get(params[:id])
    
    render 'option'
  end

  # POST /admin_options
  # POST /admin_options.xml
  def create
    if params[:options][:name] != "" and params[:options][:sub_name] == ""
      @option = Option.new
      @option.name = params[:options][:name]
      @option.priority = params[:options][:priority].to_i
      
      if @option.save
        flash[:notice] = 'Main option was successfully created.'
        redirect_to :action => 'index'
      else
       render :action => 'new'        
      end

    elsif params[:options][:name] == "" and params[:options][:sub_name] != ""
      @option = Option.get(params[:options][:main_option].to_i)
      @sub_option = @Optionsub.new
      @sub_option.name = params[:options][:sub_name]
      @sub_option.priority = params[:options][:sub_order].to_i

      if @sub_option.save
        flash[:notice] = 'Sub option was successfully created.'
        redirect_to :action => 'index'
      else
       render :action => 'new'        
      end

    end
  
    

  end

  # PUT /admin_options/1
  # PUT /admin_options/1.xml
  def update
    @menu = "option"
    @board = "option"
    @section = "edit"
    
    @option = Option.get(params[:id])
    
    @option.name = params[:option][:name]
    @option.priority = params[:option][:priority].to_i
        
      if @option.save
        redirect_to (admin_option_url)
      else
        render 'option'
      end

  end



  def option_order_update
    option_id = params[:option_id].split(',')
    
    if !option_id.nil? 
      i = 1
      option_id.each do |c|
        id = c.gsub("opt_","").to_i
        if Option.get(id) != nil
          option = Option.get(id)
          option.priority = i
          option.save
          i += 1
        end
      end
    end

  puts_message "option sorting has finished!"
  render :nothing => true
  end

  def optionsub_order_update
    optionsub_id = params[:optionsub_id].split(',')
    @option = Option.get(params[:option_id].gsub("sortables_","").to_i)
    puts_message @option.name
    
    if !optionsub_id.nil? 
      i = 1
      optionsub_id.each do |s|
        temp = s.split('_')
        optionsub = Optionsub.get(temp[1].to_i)
        optionsub.priority = i
        optionsub.save
        
        i += 1
      end
    end

    puts_message "optionsub sorting has finished!"
  render :nothing => true
  end

  def add_option
    option_name = params[:option_name]
    
    options = Option.all(:order => [:priority])

    i = 2
    options.each do |c|
      c.priority = i
      c.save
      i += 1
    end
    
    option = Option.new()
    option.name = option_name
    option.priority = 1
    option.save
    
    @option = option
    
    render :update do |page|
      page.replace_html 'created_option', :partial => 'created_option', :object => @option
    end
  end
  
  def add_optionsub
    option_id = params[:option_id]
    optionsub_name = params[:optionsub_name]
    optionsub_price = params[:optionsub_price]
    
    @option = Option.get(option_id.to_i)
    @optionsub = Optionsub.new
    @optionsub.option_id = @option.id

    max_order = Optionsub.all(:option_id => @option.id).count
        
    @optionsub.priority = max_order + 1
    @optionsub.name = optionsub_name
    @optionsub.price = optionsub_price
    
    if @optionsub.save
      puts_message "adding optionsub has finished!"
    else
      puts_message "erorr occrued!"
    end

    @option_id = option_id
    render :update do |page|
      page.replace_html 'created_optionsub', :partial => 'created_optionsub', :object => @optionsub, :object => @option_id
    end

  end

  def delete_option
    temp_option_name = params[:option_id].split('_')
    puts_message params[:option_id]
    
    option_selector = temp_option_name[0]
    id = temp_option_name[1]
    
    if option_selector == "opt-del"
      #카테고리 삭제의
      option_id = id.to_i
      @option = Option.get(id.to_i)
      @optionsubs = Optionsub.all(:option_id => @option.id)
    
    
      if @optionsubs.destroy
        puts_message "서브카테고리들 삭제 완료!"
        if @option.destroy
          puts_message "카테고리 삭제 완료!"
        end
      end
    else
    
    #서브카테고리의 삭제 
    @optionsub = Optionsub.get(id.to_i)
      if @optionsub.destroy
        puts_message "서브카테고리 삭제 완료!"
      end
    end
    
    render :nothing => true
  end
  
  def update_option
    temp_option_id = params[:option_id].split('_')
    option_name = params[:option_name]
    option_selector = temp_option_id[0]
    option_id = temp_option_id[1]
    
    if option_selector == "opt-edit"
      @option = Option.get(option_id.to_i)
      @option.name = option_name
      if @option.save
        puts_message "카테고리 업데이트 완료!"
      end
    else
      @optionsub = Optionsub.get(option_id.to_i)
      @optionsub.name = option_name
      if @optionsub.save
        puts_message "서브카테고리 업데이트 완료!"
      end
    end
    render :nothing => true
  end
  
  def discount_save
    category_name = params[:category]
    qt = params[:qt].to_i
    condition = params[:condition]
    rate = params[:rate].to_f
    mode = params[:mode]

    if Option_basic.all(:category_name => "현수막").count > 0
      @option_basic = Option_basic.first(:category_name => category_name)
    else
      @option_basic = Option_basic.new()
      @option_basic.category_name = category_name
      @option_basic.save
    end
    option_basic_id = @option_basic.id
    
    if mode == "new"
      @discount_rate = Discount_rate.new()

      @discount_rate.option_basic_id = option_basic_id
      @discount_rate.quantity = qt
      @discount_rate.rate = rate
      @discount_rate.condition = condition
      if @discount_rate.save
        puts_message "배율 추가 성공!"
      else
        puts_message "배율 추가 실패!"
      end
    else
      discount_rate_id = params[:id].to_i
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
    
    render :update do |page|
      page.replace_html 'discount_rate_div', :partial => 'discount_rate_div', :object => @discount_rate
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
      option_basic = Option_basic.first(:category_name => category_name)
    else
      option_basic = Option_basic.new()
    end
    
    option_basic.category_id = category_id
    option_basic.category_name = category_name
    option_basic.unit_price = bup
    option_basic.size_limit_flag = sl_f
    option_basic.lowest_price_flag = lp_f
    option_basic.lowest_price = lp
    option_basic.unit_price_change_by_meterial_flag = upcbm_f
    option_basic.unit_price_change_by_postproc_flag = upcbp_f
    option_basic.round_off_flag = ro_f
    option_basic.round_off_unit = ro
    option_basic.discount_rate_flag = dr_f
    
    
    # option_basic.save
    
    if option_basic.save
      render :text => "success"
    else
      puts_message "저장실패!"
    end

  end
end
