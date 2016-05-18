class User < ActiveRecord::Base
  attr_accessor :remember_token
  has_many :activities, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :categories, through: :lessons
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id",
    dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id",
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  
  enum role: [:user, :admin]

  def remember 
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
  
  def follow other_user
    active_relationships.create followed_id: other_user.id
  end
  
  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following? other_user
    following.include? other_user
  end
  
  def is_user? user
    self == user
  end
  
  def activities_feed
    Activity.where(user_id: [following.ids, self.id]).order created_at: :desc
  end
  
  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end
end
