class SessionsController < ApplicationController
  
  def new     # RESTful convention of using new for a signin page (new session)

  end

  def create  # RESTful convention - create to complete signin (create session)
    user = User.find_by_email(params[:email])
  	if user && user.authenticate(params[:password])
  		# Sign the user in and redirect to the user's show page.
  		sign_in user
  		# replace: redirect_to user to enable friendly forwarding
      redirect_back_or user
  	else
  		# use flash.now to dsiplay flash messages on rendered pages
  		# and have them disappear as soon as their is a request (unlike flash)
  		flash.now[:error] = 'Invalid email/password combination' 
  		render 'new'
  	end
  end


# old for when we used form_for:
  # def create  # RESTful convention - create to complete signin (create session)
  #   user = User.find_by_email(params[:session][:email])
  #   if user && user.authenticate(params[:session][:password])
  #     # Sign the user in and redirect to the user's show page.
  #     sign_in user
  #     redirect_to user
  #   else
  #     # use flash.now to dsiplay flash messages on rendered pages
  #     # and have them disappear as soon as their is a request (unlike flash)
  #     flash.now[:error] = 'Invalid email/password combination' 
  #     render 'new'
  #   end
  # end


  def destroy   #RESTful convention - destroy action to delete sessions (sign out)
    sign_out    # defer to sign_out function for signing out
    redirect_to root_path
  end
end
