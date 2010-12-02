# encoding: utf-8
class MyordersController < ApplicationController
  before_filter :authenticate_user!  

  def index
    if signed_in? 
      @menu = "myorder"  
      @board = "myorder"
      @section = "index"
     
      @myorders = Myorder.all(:user_del => false, :user_id => current_user.id, :order => [:updated_at.desc]).search(params[:search], params[:page])
      render 'myorder'
    else
      redirect_to '/'
    end
  end
  
  def show
    @menu = "myorder"
    @board = "myorder"
    @section = "show"
    
    @myorder = Myorder.get(params[:id].to_i)   
    
    render 'myorder'    
  end

  
  
end
