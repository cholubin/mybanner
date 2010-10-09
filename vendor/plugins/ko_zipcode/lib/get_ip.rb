require 'geokit'  
require 'ipaddr'
require 'net/http'
 require 'yajl'
 require 'uri'
 require 'yajl/http_stream'
 
def get_ip
  con = Net::HTTP.new('checkip.dyndns.org', 80)
  resp,body = con.get("/")  
  ip = body.match(/\d+\.\d+\.\d+\.\d+/)

  ip[0]
end

def guess_address(lat, lng)    
  
  url = URI.parse("http://maps.google.com/maps/api/geocode/json?latlng=#{lat},#{lng}&sensor=false&region=kr")
  results = Yajl::HttpStream.get(url) do |hash|
    hash["results"].each do |db|
      puts "========"   
      
      if db["address_components"].each do |addr_component|
        if addr_component.has_key?("types") && addr_component["types"][0] == "postal_code"           
          puts  addr_component["long_name"]     
          # puts "ok"            
        end
      end
      puts "========"   
    end
    end
  end

end

result = Geokit::Geocoders::MultiGeocoder.geocode(get_ip)  
puts  result.lat
puts result.lng

guess_address(result.lat , result.lng)