# encoding: utf-8

class Admin::SkinsController < ApplicationController
  layout "admin_layout"
  before_filter :authenticate_admin!    
        
  # GET /notices
  # GET /notices.xml
  def index
    @menu = "admininfo"
    @board = "skins"
    @section = "index"
    
    render 'skin' 
  end

end

