module SessionsHelper
    
end

def sign_in(user)
    user.remember_me!
    cookies['remember_token' + Rails.root] = { :value => user.remember_token, :expires => 8.hour.from_now }
    self.current_user = user
end

def current_user=(user)
  @current_user = user
end

def current_user
    @current_user ||= user_from_remember_token
end

def user_from_remember_token
    # remember_token = session[:remember_token]
    remember_token = cookies['remember_token' + Rails.root]
    User.first(:remember_token => remember_token) unless remember_token.nil?
end

def signed_in?
    !current_user.nil?
    
end

def sign_out        
  # cookies.delete :remember_token
  
  reset_session
  # session[:remember_token] = nil
  cookies['remember_token' + Rails.root] = nil
  
  self.current_user = nil
end  

def authenticate_user! 
  if !signed_in?
    redirect_to '/login'
  end
end

