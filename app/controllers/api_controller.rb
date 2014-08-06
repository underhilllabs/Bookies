class ApiController < ApplicationController
  respond_to :xml, :html

  def import
    unless current_user then
      flash[:error] = "must be logged in"
      redirect_to root_url
    end
    myfile = params[:file]
    xml = myfile.read
    # u = User.find(session[:user_id])
    user = current_user
    # this is blowing up the database when xml file is too large
    # So, instead pass in the filename and read file in function.
    user.import_bookmarks(xml)
    #user.import_bookmarks(xml)
    num_lines = xml.split("\n").size
    flash[:notice] = "Import job is in the queue! read in #{num_lines} lines."
    redirect_to root_url
  end

  def upload
  end

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
