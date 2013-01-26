module SessionsHelper

  # sign_in function for signing in users
  # in helper in order to be used as module - facility for packaging funcitons
  # together and including them in multiple places
  def sign_in(user)
  	# uses cookies utility supplied by Rails - can be used as if it were a hash
  	# each element in the cookie is a hash of a value and optional expires date
  	cookies.permanent[:remember_token] = user.remember_token
  	# create the current_user to be accessible in both controllers and views
  	# which enables things like:
    # <%= current_user.name %> and redirect_to current_user
    # use self to avoid simply creating a local variable
  	self.current_user = user     # this is an assignment which we must define
  end

  def signed_in?    # useful z.B. for conditionals in views (show if signed in)
    !current_user.nil?
  end
  # defining assignment to current_user 
  # = in method def makes it so self.current_user = is automatically converted
  # current_user=(...)
  # this is like a modified setter 
  def current_user=(user)   
    @current_user = user    
  end

  # method to find current user using the remember_token
  def current_user
    # ||= ("or equals") sets left side to value on right only if left side undef
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end
  # we place sign_out at the end of our sessions_helper.rb, since this 
  # represents the end of a session, and all else is in between
  def sign_out
    self.current_user = nil    
    cookies.delete(:remember_token)
  end

end
