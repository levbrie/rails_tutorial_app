# we want to create a database index on the email column and then 
# require that the index be unique
# uses Rails method add_index to add an index on the email column of the
# users table, and unique: true option enforces uniqueness
class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, unique: true
  end
end
