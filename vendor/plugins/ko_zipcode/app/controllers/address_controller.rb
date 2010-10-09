# encoding: utf-8  

class AddressController < ApplicationController      
  
  def input
    
  end            
  
  def search 
    # @ip_based_address = Address.geo_search       
    @addresses = Address.search(params)    

  end
end
