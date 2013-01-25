# Migration to add a remember_token to the users table

class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
  	add_column 	:users, 	:remember_token, 	:string
  	# we add an index to to remember_token column
  	# because we expect to retrieve users by remember_token (for sessions)
  	add_index	:users,		:remember_token
  end
end
