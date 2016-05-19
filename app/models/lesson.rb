class Lesson < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :user_answers, dependent: :destroy
  has_many :words, through: :user_answers
  
  after_update :create_learned_activity

  accepts_nested_attributes_for :user_answers, allow_destroy: true

  enum status: {unfinished: 0, finished: 1}

  def build_user_answers
    words = category.words.order("RANDOM()").limit Settings.lesson.word_limit
    words.each do |word|
      user_answers.create! user: user, category: category, word: word
    end
  end

  def correct_answer_count
    user_answers.correct.count unless new_record?
  end
  
  def total_word_count
    words.count
  end
  
  private
  def create_learned_activity
    Activity.create target_id: self.id, type_action: :learned,
      user_id: self.user.id,
      number: self.correct_answer_count
  end
end
