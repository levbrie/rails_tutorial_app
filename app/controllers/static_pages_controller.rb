class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		# define @micropost for rendering micropost compose view when signed in
  		@micropost = current_user.microposts.build 
  		# adding a feed insteance variable to the home action
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  	
  end

  def help
  end

  def about
  end

  def contact 
  end
end
