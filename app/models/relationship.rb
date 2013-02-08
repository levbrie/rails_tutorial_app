class Relationship < ActiveRecord::Base
  attr_accessible :followed_id  # only followed_id is accessible, not follower_id

  # Rails infers names of foreign keys from corresponding symbols
  # follower_id from :follower and followed_id from :followed, but there is 
  # now Followed or Follower model, only User model so we need to supply that
  belongs_to :follower, class_name: "User"		
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
