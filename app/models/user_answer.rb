class UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :word
  belongs_to :answer
  belongs_to :lesson

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :word_id, presence: true
  validates :lesson_id, presence: true

  scope :correct, ->{joins(:answer).where answers: {is_correct: true}}
end
