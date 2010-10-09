# encoding: utf-8   

require 'spec_helper'

describe Address do
  before(:each) do 
    @param_dong = {:dong  => "삼성동"}
    @param_building = {:building  => "주공"} 
    @param_dong_building ={:dong  => "삼성동", :building  => "주공"}
  end
  describe "#search with dong" do
    it "should return zipcode and address" do          
      zipcode = []                           
      address = []
      Address.search(@param_dong).select do |db| 
        address << db.address
        zipcode << db.zipcode
      end
      address.should include "서울 관악구 삼성동 주공1차아파트 101-107"  
      zipcode.should include "151793"  
    end
  end
    
  describe "#search with building" do
    it "should return zipcode and address" do          
      zipcode = []                           
      address = []
      Address.search(@param_building).select do |db| 
        address << db.address
        zipcode << db.zipcode
      end
      address.should include "서울 관악구 삼성동 주공1차아파트 101-107"  
      zipcode.should include "151793"  
    end
  end
  
  describe "#search with dong and building" do 
    it "should return zipcode and address"do
    zipcode = []                           
    address = []    
    Address.search(@param_dong_building).select do |db| 
      address << db.address  
      zipcode << db.zipcode
    end
    address.should include "서울 관악구 삼성동 삼성산주공아파트 301-309"  
    zipcode.should include "151704"
    end
  end  
  
  describe "#geo_search" do
    it "should return near address" do
      zipcode = []                           
      address = []    
      Address.geo_search.address.should_not == nil
    end 
  end
end
