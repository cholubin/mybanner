ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
 map.pay '/pay', :controller => 'checkout', :action => 'process_payment'
 map.pay_reulst '/pay_result', :controller => 'checkout', :action => 'pay_result' 
 map.request_payment "/request_payment/:name/:pay_method/:total_price", :controller => "checkout", :action => "request_payment"  

end
