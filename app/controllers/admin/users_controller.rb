class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  
  def index
    @users = User.all
  end
  
  def destroy
    @user = User.find params[:id]
    @user.destroy
    flash[:success] = t "admin_success_delete_user"
    redirect_to admin_users_path
  end
end
