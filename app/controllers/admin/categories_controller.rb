class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action except: [:index, :new, :create] { 
    @category = load_object Category
  }
  
  def index
    @categories = Category.paginate page: params[:page],
      per_page: Settings.category.per_page
  end
  
  def show
    @word = Word.new
    Settings.word.number_of_answers.times do
      @answer = @word.answers.build
    end
    @words = @category.words.paginate page: params[:page], 
      per_page: Settings.word.per_page
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "category_created"
      redirect_to admin_categories_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @category.update_attributes category_params
      flash[:success] = t "category_updated"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end
  
  def destroy
    if @category.destroy
      flash[:success] = t "category_deleted"
    else
      flash[:danger] = t "category_not_deleted"
    end
    redirect_to admin_categories_path
  end
  
  private
  def category_params
    params.require(:category).permit :title, :description, :image
  end
end
