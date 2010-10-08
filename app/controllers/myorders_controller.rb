# encoding: utf-8
class MyordersController < ApplicationController
  before_filter :authenticate_user!  

  def index
    if signed_in? 
      @menu = "home"  
      @board = "myorder"
      @section = "index"
     
      @mycarts = Myorder.all(:user_id => current_user.id)
      render 'myorder'
    else
      redirect_to '/'
    end

  
  end
end
