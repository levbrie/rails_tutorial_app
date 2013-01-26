class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  end
  
  # adding an @user variable to the new action
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user     # signs in the user upon signup
      flash[:success] = "Welcome to the Sample App!"
  		# Handle a successful save.
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  # RESTful edit action that starts by finding the user
  def edit
    @user = User.find(params[:id])
  end
end
