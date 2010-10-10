# encoding: utf-8  

class AddressController < ApplicationController      
  
  def input
    
  end            
  
  def search 
    # @ip_based_address = Address.geo_search       
    @addresses = Address.search(params)    

  end
  
  def search_ajax
    # @ip_based_address = Address.geo_search       
    @addresses = Address.search(params)    
    
    select_str = "<label for='address-selector'>주소선택</label>" +
                "<select id='address-selector'>" +
			          "<option value='' selected>선택해주세요.</option>" +
			          "<option value=''>-----------------</option>"
		
    str = ""
    @addresses.each do |f|
      if f.address != nil; address = f.address; else address = ""; end
      
      str += "<option value='"+f.zipcode+"'>"+ address+"</option>"
    end
  		
		
		select_str = select_str + str + "</select>"

		
    render :text => select_str
  end
end
