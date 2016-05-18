class Activity < ActiveRecord::Base
  belongs_to :user
  
  enum type_action: {learned: 0, followed: 1, unfollowed: 2}
end
