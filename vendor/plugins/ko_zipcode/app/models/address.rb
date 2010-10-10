require 'rubygems'
require 'geokit'     
require 'ipaddr'
require 'net/http'
require 'yajl'
require 'uri'
require 'yajl/http_stream'
class Address
  # include CustomInitializers
  include DataMapper::Resource   
  property :id, Serial 
  property :zipcode, String
  property :city, String
  property :si_goon_goo, String
  property :dong, String
  property :building, String   
  property :address, String

 attr_reader :zipcode, :city, :dong, :building, :address  
  validates_is_unique :address 
      
 def self.search(params)   
   if params == nil
     addresses = nil
   elsif 
     addresses = self.all    
     addresses = addresses.with_dong(params[:dong])if params[:dong]
     addresses = addresses.with_building(params[:building]) if params[:building]
     addresses = addresses.with_address(params[:address]) if params[:address]    
     addresses
   end
 end
 
 def self.geo_search
    result = Geokit::Geocoders::MultiGeocoder.geocode(get_ip)
    guess_address(result.lat , result.lng)   
 end  
 
private
 def self.with_dong(dong)
   all(:dong.like => "%#{dong}%") 
 end     
     
 
 def self.with_building(building)
   all(:building.like => "%#{building}%") 
 end 
 
 def self.with_address(address)
   all(:address.like => "%#{address}%") 
 end 
 


 def self.get_ip
   con = Net::HTTP.new('checkip.dyndns.org', 80)
   resp,body = con.get("/")  
   ip = body.match(/\d+\.\d+\.\d+\.\d+/)

   # return IPAddr.new(ip[0]) 
   ip[0]
 end
 

 def self.guess_address(lat, lng)    
   result = []
   url = URI.parse("http://maps.google.com/maps/api/geocode/json?latlng=#{lat},#{lng}&sensor=false&region=kr")
   results = Yajl::HttpStream.get(url) do |hash|
     hash["results"].each do |db| 
       if db["address_components"].each do |addr_component|
         if addr_component.has_key?("types") && addr_component["types"][0] == "postal_code"           
           result << addr_component["long_name"]             
         end
       end 
     end
   end 
   # return result[0].gsub!(/\-/,"")   
   return Address.first(:zipcode => result[0].gsub!(/\-/,""))
 end

 end
end
