class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if =>lambda{ params[:api_key].present?}
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
    Resque.enqueue(BookmarkImporter, user.id, myfile)
    # user.import_bookmarks(xml)
    #user.import_bookmarks(xml)
    #num_lines = xml.split("\n").size
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
      @tag = Tag.find(params[:tag])
      @bookmarks = @user.bookmarks.where(tag: @tag).order("updated_at DESC")
    else
      @bookmarks = @user.bookmarks.order("updated_at DESC")
    end
    respond_with @bookmarks
  end

  # POST /api/posts/add
  def posts_add
    u = User.find(params[:user_id])
    if (u && u.api_token == params[:api_token])
      @bookmark = Bookmark.where(user_id: params[:user_id], url: params[:url] ).first_or_initialize
      @bookmark.update(bookmark_params)
      @bookmark.save
    end
    redirect_to root_url
  end
    
  # Never trust parameters from the scary internet, only allow the white list through.
  def bookmark_params
    params.permit(:url, :title, :private, :desc, :is_archived, :tag_list)
  end
end
