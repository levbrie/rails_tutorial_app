class Micropost < ActiveRecord::Base
  attr_accessible :content			# removed user_id so it can't be changed
  belongs_to :user
  validates :content, presence: true, length: {maximum: 140}
  validates :user_id, presence: true

  # order the microposts with default_scope
  default_scope order: 'microposts.created_at DESC'	#DESC is SQL for descending

  def self.from_users_followed_by(user)
  	# replaced:
  	# 		followed_user_ids = user.followed_user_ids
  	# 		where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  	# with:
  	followed_user_ids = "SELECT followed_id FROM relationships
  												WHERE follower_id = :user_id"
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
  				user_id: user.id)
  end
end
