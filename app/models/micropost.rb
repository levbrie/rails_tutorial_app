class Micropost < ActiveRecord::Base
  attr_accessible :content			# removed user_id so it can't be changed
  belongs_to :user
  validates :content, presence: true, length: {maximum: 140}
  validates :user_id, presence: true

  # order the microposts with default_scope
  default_scope order: 'microposts.created_at DESC'	#DESC is SQL for descending
end
