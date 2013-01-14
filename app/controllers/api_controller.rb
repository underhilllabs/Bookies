class ApiController < ApplicationController
  respond_to :xml

  def index
    if(User.find(params[:id]))
      @user = User.find(params[:id])
    else 
      @user.username = ""
    end
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
    if(params[:tag])
      #@tags = params[:tag].split("+")
      @tag = Tag.find(params[:tag])
      @bookmarks = @user.bookmarks.order("updated_at DESC")
    else
      @bookmarks = @user.bookmarks.order("updated_at DESC")
    end
    respond_with @bookmarks
  end
end
