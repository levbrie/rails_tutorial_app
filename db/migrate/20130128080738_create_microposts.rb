class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # since we expect to retrieve all microposts associated with a user id in 
    # reverse order of creation, we add an index on user_id and created_at 
    # columns, so that this can be accomplished extremely quickly
    # note: this arranges for Rails to create a multiple key index
    add_index :microposts, [:user_id, :created_at]
  end
end
