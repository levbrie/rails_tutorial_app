class UsersController < ApplicationController
  # before filter arranges for a method to be called before the given actions
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy]  
  # 2nd before filter to call the correct_user method and make sure only the 
  # current user can only edit his account and nothing else
  before_filter :correct_user,    only: [:edit, :update]
  # add before filter restricting destroy action to admins
  before_filter :admin_user,      only: :destroy

  def index
    # pull all the users out of the database and assign them to @users i.v.
    # @users = User.all 
    # for pagination, we replace above with:
    @users = User.paginate(page: params[:page])  # paginate users in index 
  end

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

  def destroy
    # use method chaining to combine find and destroy into one line
    User.find(params[:id].destroy)
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private 
  # everything after this is private?
    def signed_in_user
      unless signed_in?
        # keep track of location for friendly forwarding to return to location
        # user requested after a successful sign-in
        store_location       
        redirect_to signin_path, notice: "Please sign in." unless signed_in?
        # the above uses a shortcut for setting flash[:notice] by passing an 
        # options hash to the redirect_to function.  It is equivalent to:
        #   flash[:notice] = "Please sign in."
        #   redirect_to signin_path
      end
    end

    def correct_user 
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    # used to make sure only admins can destroy users
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
