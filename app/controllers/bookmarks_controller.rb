class BookmarksController < ApplicationController
  before_action :require_login, only: [:update, :edit]
  before_action :set_bookmark, only: [:show, :edit, :update, :archive, :destroy]
  respond_to :html

  # GET /bookmarks.xml
  def index
    @bookmarks = Bookmark.all.page(params[:page])
  end
  
  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/:id
  def show
  end

  # get /bookmarks/:id/edit
  def edit
    if session[:user_id] == @bookmark.user_id
      respond_with @bookmark
    else 
      flash[:error] = "Sorry, you do not have permissions to edit Bookmark!"
      redirect_to root_url
    end
  end
 
  # POST /bookmarks
  def create
    @bookmark = Bookmark.find_or_initialize_by(:user_id => params[:bookmark][:user_id], :url => params[:bookmark][:url] )
    @bookmark.update(bookmark_params)
    if @bookmark.save
      # call the archive method here only
      @bookmark.archive_the_url
      redirect_to(@bookmark, :notice => 'Bookmark was successfully created.', :locals => {:close_window => params[:bookmark][:is_popup]})
      # if params[:bookmark][:is_popup]
      #   redirect_to(@bookmark, :notice => 'Close the Window!', :locals => {:close_window => 1})
      # else  
      #   redirect_to(@bookmark, :notice => 'Bookmark was successfully created.')
      # end
    else
      flash[:warning] = "There was a problem saving that bookmark."
      render :action => "new" 
    end
  end

  def update
    # check if user has permission to edit bookmark
    if session[:user_id] != @bookmark.user_id
      flash[:error] = "Sorry, you do not have permission to edit another user's bookmarks!"
      redirect_to root_url
    end
    # warning: update_attributes side-steps validation
    if @bookmark.update(bookmark_params)
      # call the archive method here only
      @bookmark.archive_the_url
      flash[:notice] = "\"#{@bookmark.title}\" was successfully updated."
      if params[:bookmark][:is_popup]
        redirect_to(@bookmark, :notice => 'Close the Window!', :locals => {:close_window => 1})
      else  
        redirect_to(@bookmark, :notice => 'Bookmark was successfully created.')
      end
    else 
      flash[:notice] = "Unable to update bookmark."
      redirect_to root_url
    end
  end

  # GET /bookmarks/user/:id
  def user
    @user = User.find(params[:id])
    # FIXME TODO
    if current_user && current_user.id.to_s == params[:id] 
      @bookmarks = Bookmark.where(user_id: params[:id]).page(params[:page]).per_page(20)
    else
      @bookmarks = Bookmark.where(user_id: params[:id]).where(private: nil).page(params[:page]).per_page(19)
    end
  end

  def user_bookmarks
    @bookmarks = Bookmark.where(:user_id => current_user.id)
  end

  # GET /bookmark/archive/1
  def archive
    render layout: "archive"
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if session[:user_id] != @bookmark.user_id
      flash[:error] = "Sorry, you do not have permission to delete this bookmark."
      redirect_to root_url
    else 
      @bookmark.archive.destroy if @bookmark.archive
      # @bookmark.archive.try(:destroy)
      @bookmark.destroy
      redirect_to root_url, :notice => "#{@bookmark.title} was deleted!"
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def bookmarklet
    unless session[:user_id] 
      flash[:info] = "Please Sign In."
      session[:return_to] = request.fullpath
      redirect_to login_url
    end
    @bookmark = Bookmark.find_or_create_by(:url => params[:address], :user_id => session[:user_id])
  end

  def tag
    @bookmarks = Bookmark.tagged_with(params[:name]).page(params[:page]) 
    @name = params[:name]
  end

  private
  def require_login
    unless session[:user_id]
      flash[:info] = "Please Sign In."
      redirect_to login_url
    end
  end

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bookmark_params
    params.require(:bookmark).permit(:url, :title, :private, :desc, :is_archived, :tag_list)
  end
end
