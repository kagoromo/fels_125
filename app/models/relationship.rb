class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  
  validates :follower, presence: true
  validates :followed, presence: true

  before_save :create_followed_activity
  before_destroy :create_unfollowed_activity

  private
  def create_followed_activity
    Activity.create user_id: follower_id, target_id: followed_id,
      type_action: :followed
  end

  def create_unfollowed_activity
    Activity.create user_id: follower_id, target_id: followed_id,
      type_action: :unfollowed
  end
end
