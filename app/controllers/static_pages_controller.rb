class StaticPagesController < ApplicationController
  def home
    @activities = current_user.activities_feed
      .paginate page: params[:page], per_page: Settings.activity.per_page if logged_in?
  end

  def help
  end

  def about
  end
end
