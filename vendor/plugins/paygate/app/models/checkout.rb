require 'state_machine'
class Checkout

  include DataMapper::Resource

  property :id, Serial       
  property :state, String
  property :total_price, Float, :required => true
  property :pay_method, String, :required => true
  property :name, String, :required => true    
  property :number, String, :required => true
  # property :socialnumber, String 
  # property :carrier, String
  # property :mobile_phone_number, String   
  property :package_reciever, String
  property :phone, String
  property :deliverty_method, String
  property :zipcode, String
  property :address, String
  property :detail_address, String  
  property :created_at, DateTime, :required => true
  property :updated_at, DateTime, :required => true
  
 attr_reader :total_price, :pay_method, :name  
 attr_accessor :state
 validates_with_method :totoal_price, :method => :check_price #, :if => Proc.new {|t| t.pay_method == "card" }
 before :save, :generate_order_number
 # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)  
 state_machine :initial => :address do
    event :next do
      transition :address => :delivery  
      transition :delivery => :confirm    
      transition :confirm => :complete
      transition :complete => :complete       
    end
    
    event :previous do   
      transition :address => :address  
      transition :delivery => :address   
      transition :confirm => :delivery   
      transition :complete => :confirm 
    end    
  end            
 # State Machine     
 private        
 
 def generate_order_number
   record = true
   while record
     random = "M#{Array.new(9){rand(9)}.join}"   
     record = Address.first(:number => random) 
   end
   self.number = random
 end
 
 def check_price
   price = self.total_price
   case self.pay_method 
   when "card"
     price >= 1000
   when "mobile"  
     price >= 100
   else
     return false
   end
 end 
 
end
