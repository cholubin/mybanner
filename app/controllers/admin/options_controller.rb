# encoding: utf-8

class Admin::OptionsController < ApplicationController
  before_filter :authenticate_admin!      
  # GET /admin_options
  # GET /admin_options.xml
  def index
    @menu = "option"
    @board = "option"
    @section = "index"
      
    @options = Option.all(:order => [ :priority])

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

  # # DELETE /admin_options/1
  # # DELETE /admin_options/1.xml
  # def destroy
  #   puts "==============================="
  #   @option = Option.get(params[:id])
  #   @subcategoris = Optionsub.all(:option_id => @option.id)
  #   
  # 
  #   if @subcategoris.destroy
  #     @option.destroy
  #     redirect_to admin_options_url      
  #   else
  #     puts_message "Error occured during deleting optionsubs"
  #     redirect_to admin_options_url      
  #   end
  # end
  # 
  # def destroy_sub
  #   @options = Option.all
  #   @optionsub = @options.optionsubs.get(params[:id].to_i)
  #   
  #   if @optionsub.destroy
  #     redirect_to admin_options_url      
  #   else
  #     puts_message "Error occured during deleting optionsubs"
  #     redirect_to admin_options_url      
  #   end
  # end  

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
    
    @option = Option.get(option_id.to_i)
    @optionsub = Optionsub.new
    @optionsub.option_id = @option.id

    max_order = Optionsub.all(:option_id => @option.id).count
        
    @optionsub.priority = max_order + 1
    @optionsub.name = optionsub_name
    
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
  
end
