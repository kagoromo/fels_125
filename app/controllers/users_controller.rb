class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :load_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @activities = @user.activities_feed
      .paginate page: params[:page], per_page: Settings.activity.per_page if logged_in?
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "success_signup"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success_edit"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find params[:id]
  end
end
