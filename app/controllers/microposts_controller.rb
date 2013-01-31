class MicropostsController < ApplicationController
	# restrict access to create and destroy to signed in users own posts
	before_filter :signed_in_user, only: [:create, :destroy]
	# check that current user actually has a micropost with the given id
	before_filter :correct_user, 	 only: :destroy 	

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_path
		else
			# to prevent failed submissions from breaking (because they expect an
			# @feed_items iv), we suppress the feed entirely by assigning it an 
			# empty array
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_back_or root_path
	end

	private

		def correct_user
			@micropost = current_user.microposts.find_by_id(params[:id])
			redirect_to root_path if @micropost.nil?
		end
end