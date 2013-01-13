class ApiController < ApplicationController
  respond_to :html, :json, :xml, :rss

  def index
    @user = User.find(params[:id])
    @bookmarks = @user.bookmarks.order("updated_at DESC")
    respond_with @bookmarks
  end

  def posts_all
    if params[:id]
      current_id = params[:id]
    else
      current_id = session[:user_id]
    end
    @user = User.find(current_id)
    @bookmarks = @user.bookmarks.order("updated_at DESC")
    respond_with @bookmarks
  end
end
