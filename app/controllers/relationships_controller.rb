class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		# respond to Ajax request using respond_to method that takes format 
		# of html or js
		# *** N.B. only 1 line gets executed here, with an Ajax request
		# Rails automatically calls a JavaScript Embedded Ruby file (create.js.erb)
		respond_to do |format|
			format.html {redirect_to @user}
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		respond_to do |format| 
			format.html {redirect_to @user}
			format.js
		end
	end
end