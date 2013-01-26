class UsersController < ApplicationController
  # before filter arranges for a method to be called before the given actions
  before_filter :signed_in_user, only: [:edit, :update]  # i.e. these actions
  # 2nd before filter to call the correct_user method and make sure only the 
  # current user can only edit his account and nothing else
  before_filter :correct_user, only: [:edit, :update]

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
    # no longer needed: @user = User.find(params[:id])
  end

  def update
    # no longer needed because of correct_user before filter:
    #   @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      # we sign in user as part of a successful profile update because
      # remember token gets reset when user is saved, this also prevents 
      # hijacked sessions from continuing after user info is changes
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private 
  # everything after this is private?
    def signed_in_user
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
      # the above uses a shortcut for setting flash[:notice] by passing an 
      # options hash to the redirect_to function.  It is equivalent to:
      #   flash[:notice] = "Please sign in."
      #   redirect_to signin_path
    end

    def correct_user 
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
