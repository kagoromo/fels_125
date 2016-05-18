class Word < ActiveRecord::Base
  belongs_to :category

  has_many :answers, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :lessons, through: :user_answers

  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :reject_answers

  validates_presence_of :question
  validate :at_least_one_correct_answer

  scope :all_words, -> (category_id) {where category_id: category_id}
  scope :learned, -> (user_id) {joins(user_answers: [:lesson, :answer]).
    where("lessons.user_id = ? and answers.is_correct = ? and
    answers.id == user_answers.answer_id", user_id, true).distinct}
  scope :not_learned, -> (user_id) {where.not id: Word.learned(user_id)}

  class << self
    def filter_words_by user_id, category_id, filter_type
      if category_id.present?
        case filter_type
          when Settings.category.filter_type.learned
            Word.all_words(category_id).learned user_id
          when Settings.category.filter_type.not_learned
            Word.all_words(category_id).not_learned user_id
          else
            Word.all_words(category_id)
        end
      else
        Word.all
      end
    end
  end

  private
  def reject_answers (attributed)
    attributed['answer'].blank?
  end

  def at_least_one_correct_answer
    valid = false
    answers.each do |answer|
      valid = answer.is_correct? ? true : valid unless answer.
        marked_for_destruction?
    end
    errors.add :answers, I18n.t("at_least_one_correct_answer") unless valid
  end
end
