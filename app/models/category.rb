class Category < ActiveRecord::Base
  has_many :lessons, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :words, dependent: :destroy
  
  def learned_word_count_of user
    words.learned(user.id).count
  end
  
  def total_word_count
    words.count
  end
end
