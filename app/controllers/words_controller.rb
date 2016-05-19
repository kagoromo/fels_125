class WordsController < ApplicationController
  def index
    @categories = Category.all
    @words = Word.filter_words_by(current_user.id, params[:category_id], params[:filter_type])
      .paginate(page: params[:page], per_page: Settings.word.index_per_page)
      .includes(:answers)
  end
end
