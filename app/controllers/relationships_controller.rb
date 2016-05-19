class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find params[:user_id]
    @action = params[:id]
    if @action == "following"
      @users = @user.following.paginate page: params[:page], per_page: Settings.user.per_page
    elsif @action == "followers"
      @users = @user.followers.paginate page: params[:page], per_page: Settings.user.per_page
    end
  end

  def create
    @user = User.find params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end

