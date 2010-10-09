ActionController::Routing::Routes.draw do |map|
  map.address '/address/input', :controller => 'address', :action => 'input'
  map.address '/address/search.:format', :controller => 'address', :action => 'search'  
end
