class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	# respond_to block hoisted out of create and destroy methods and into the 
	# controller itself and respond_with used to refer to it to make the code 
	# more compact
	respond_to :html, :js

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		# respond to Ajax request using respond_to method that takes format 
		# of html or js
		# *** N.B. only 1 line gets executed here, with an Ajax request
		# Rails automatically calls a JavaScript Embedded Ruby file (create.js.erb)
		# THE FOLLOWING CODE WAS REFACTORED using the respond_with method
		# taking care of determining whether to handle html or js for us
		# respond_to do |format|
		# 	format.html {redirect_to @user}
		# 	format.js
		# end
		respond_with @user
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		# AS ABOVE, THE FOLLOWING CODE WAS REFACTORED using the respond_with method
		# taking care of determining whether to handle html or js for us	
		# respond_to do |format| 
		# 	format.html {redirect_to @user}
		# 	format.js
		# end
		respond_with @user
	end
end