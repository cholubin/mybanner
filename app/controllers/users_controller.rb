# encoding: utf-8

class UsersController < ApplicationController
  # jQuery 대응 레이아웃 추가
  layout "ajax-load-page"
  
  # GET /users
  # GET /users.xml
  def index
  	
    @users = User.search(params[:search], params[:page])
    @total_count = User.search(params[:search],"").count
        
    @menu = "home"
    @board = "user"
    @section = "index"
    
    render 'user'
  end

  # GET /users/1
  # GET /users/1.xml
  def show

    @user = User.get(params[:id])
        
    if signed_in? && @user.id == current_user.id
      @menu = "home"
      @board = "user"
      @section = "show"
    
      render 'user'
    else
      redirect_to '/'
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    @menu = "home"
    @board = "user"
    @section = "new"
    
    render 'user'
    
  end

  # GET /users/1/edit
  def edit
    @user = User.get(params[:id])
        
    if signed_in? && @user.id == current_user.id
      @menu = "home"
      @board = "user"
      @section = "edit"

      render 'user'
    else
      redirect_to '/'
    end
    
  end

  def check_id
    input_user_id =  params[:user_id]
    user_cnt = User.all(:userid => input_user_id).count
    
    if user_cnt > 0
      render :text => "dup"
    else
      render :text => "non_dup"
    end
  end
  
  def create

    @menu = "home"
    @board = "user"
        
    @user = User.new
    @user.userid = params[:userid]
    @user.name = params[:name]
    @user.password = params[:password]
    @user.email = params[:email]
    
    flash[:notice] = "<ul>"
    
    if params[:userid] == ""
      flash[:notice] += "<li>사용자 아이디를 입력하세요.</li>"
    end

    if params[:name] == ""
      flash[:notice] += "<li>사용자 이름을 입력하세요.</li>"      
    end

    if params[:password] == ""
      flash[:notice] += "<li>비밀번호를 입력하세요.</li>"      
    end

    if params[:email] == ""
      flash[:notice] += "<li>이메일 주소를 입력하세요.</li>"      
    end
    
    
    
    if @user.userid == nil or @user.name == nil or @user.password == nil or @user.email == nil
      @section = "new"        
      flash[:notice] += "</ul>"     
      render 'user' 
    else
        if not User.first(:userid => params[:userid]).nil? # 아이디 중복인 경우 ========================== 
          flash[:notice] += "<li>이미 사용하고 있는 아이디 입니다.</li>"
          flash[:notice] += "</ul>"       
          @section = "new"        
          render 'user'    
        else
          if @user.save
            @section = "index"
            sign_in @user
            render 'pages/congratulations'

          else
            @section = "new"        
            render 'user'
          end      
        end
    end
        


  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.get(params[:id])

    if signed_in? && @user.id == current_user.id
      @menu = "home"
      @board = "user"
      @section = "edit"
    

      if @user.has_password?( params[:current_password])
        
        if params[:new_password] != ""

          @user.update_password(params[:new_password])
          @user.email = params[:email]
          @user.tel = params[:tel]
          @user.mobile = params[:mobile]
          @user.zip = params[:zip]
          @user.addr1 = params[:addr1]
          @user.addr2 = params[:addr2]
          
          if @user.save
            render :text => "수정완료"  
          else
            flash[:notice] = "오류가 발생했습니다. 다시 시도해주시기 바랍니다."
            render 'user'
          end


        else  #메일만 수정하는 경우       
          @user.email = params[:email]
          @user.tel = params[:tel]
          @user.mobile = params[:mobile]
          @user.zip = params[:zip]
          @user.addr1 = params[:addr1]
          @user.addr2 = params[:addr2]
          
          if @user.save
            render :text => "수정완료" 
          else
            flash[:notice] = "오류가 발생했습니다. 다시 시도해주시기 바랍니다."
            render 'user'
          end 
        end
      
      else
       render :text => "비밀번호 오류"
      end
      
      
      
    else
      redirect_to '/'
    end
      

  end



  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    
    @user = User.get(params[:user_id])
    
    if signed_in? && current_user.id == @user.id

      begin
        user_dir = "#{RAILS_ROOT}" + "/public/user_files/#{current_user.userid}/"
        FileUtils.rm_rf user_dir
        
        puts_message "사용자 폴더 삭제 성공!"
      rescue
        puts_message "사용자 폴더 삭제 실패!"
      end
      
      # 탈퇴 테이블로 이동 
        @user_widthdraw = User_widthdraw.new
        @user_widthdraw.userid = @user.userid
        @user_widthdraw.name = @user.name
        @user_widthdraw.email = @user.email
        @user_widthdraw.withdrawal_reason = params[:reason]
        @user_widthdraw.save
        
      
      begin
        @freeboards = Freeboard.all(:user_id => current_user.id)  
        @freeboards.destroy
      
        @mytemplates = Mytemplate.all(:user_id => current_user.id)
        @mytemplates.destroy
      
        @myimages = Myimage.all(:user_id => current_user.id)  
        @myimages.destroy

        @usertempopenlists = Usertempopenlist.all(:user_id => current_user.id)
        @usertempopenlists.destroy
      rescue
        puts_message "사용자 관련 테이블 삭제 진행중 오류 발생!"
      end
      
      if @user.destroy
        sign_out
        render :text => "success"
      else
        puts_message "사용자 테이블 삭제 진행중 오류 발생!"
        puts @user.errors
      end
            
      # @menu = "home"
      # @board = "user"
      # @section = "edit"
      
      # render 'users/withdrawal_finished'
      # render '/users/withdrawal_finished'  이경우에는 users컨트롤러가 아닌 users폴더내의 템플릿을 참고하게 된다. 즉 기본 레이아웃을 가져오지 않는다.
    else
      render :text => "fail"
    end
  end
  
  
  def id_check

      # 중복아이디 체크 
     @user = User.get(:userid => params[:user_id].to_i)
     # puts @user.name

     render :update do |page|
       page.replace_html 'id_check', :partial => 'id_check', :object => @user
     end   

  end
    
end
