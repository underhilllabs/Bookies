class BookmarksController < ApplicationController
  before_action :require_login, only: [:update, :edit, :bookmarklet]
  before_action :set_bookmark, only: [:show, :edit, :update, :archive, :destroy]
  respond_to :html

  def update
    tags_arr = set_tags(params[:bookmark][:tags])
    tags_arr.each do |tag|
      Tag.where(:name => tag, :bookmark_id => params[:id]).first_or_create
    end
    # check if user has permission to edit bookmark
    if session[:user_id] != @bookmark.user_id
      flash[:error] = "Sorry, you do not have permission to edit another user's bookmarks!"
      redirect_to root_url
    end
    # warning: update_attributes side-steps validation
    if @bookmark.update(bookmark_params)
      # now delete tags not passed in
      t_missing = Tag.where("bookmark_id = ?", @bookmark.id).where("name not in (?)", tags_arr).pluck(:id)
      Tag.destroy(t_missing)
      flash[:notice] = "\"#{@bookmark.title}\" was successfully updated."
    end
    redirect_to root_url
  end

  def user
    @user = User.find(params[:id])
    # FIXME TODO
    if current_user && current_user.id.to_s == params[:id] 
      @bookmarks = Bookmark.where(user_id: params[:id]).order(updated_at: :desc).page(params[:page]).per_page(20)
    else
      @bookmarks = Bookmark.where(user_id: params[:id]).order(updated_at: :desc).where(private: nil).page(params[:page]).per_page(20)
    end
  end

  # GET /bookmarks/:id
  def show
  end

  # GET /bookmarks.xml
  def index
    @bookmarks = Bookmark.order("updated_at DESC").page(params[:page])
    respond_with(@bookmarks)
  end
  
  def user_bookmarks
    @bookmarks = Bookmark.order("updated_at DESC").where(:user_id => current_user.id)
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    tag_str = set_tags(params[:bookmark][:tags])
    # use find_or_create
    @bookmark = Bookmark.where(:user_id => params[:bookmark][:user_id], :hashed_url => Digest::MD5.hexdigest(params[:bookmark][:url]) ).first_or_initialize 
    @bookmark.update(title: params[:bookmark][:title], url: params[:bookmark][:url], title: params[:bookmark][:title], desc: params[:bookmark][:desc], is_archived: params[:bookmark][:is_archived], private: params[:bookmark][:private], user_id: params[:bookmark][:user_id]) 
    if @bookmark.save
      # create the tags
      save_tags(tag_str)
      if params[:bookmark][:is_popup]
        redirect_to(@bookmark, :notice => 'Close the Window!', :locals => {:close_window => 1})
      else  
        redirect_to(@bookmark, :notice => 'Bookmark was successfully created.')
      end
    else
      flash[:warning] = "There was a problem saving that bookmark."
      render :action => "new" 
    end
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
      @bookmark.destroy
      # added these 2 lines because tags are not getting deleted!
      # title = @bookmark.title
      # Bookmark.destroy(params[:id])
      # @bookmark.destroy

      redirect_to root_url, :notice => "#{@bookmark.title} was deleted!"
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def new
    @bookmark = Bookmark.new()
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def bookmarklet
    # @bookmark = Bookmark.new(:tags => [Tag.new])
    @bookmark = Bookmark.where(:url => params[:address], :user_id => session[:user_id]).first_or_initialize()
  end

  # get /bookmarks/:id/edit
  def edit
    @tags = @bookmark.tags
    if session[:user_id] == @bookmark.user_id
      respond_with @bookmark
    else 
      flash[:error] = "Sorry, you do not have permissions to edit Bookmark!"
      redirect_to root_url
    end
  end

  private
  def require_login
    unless session[:user_id]
      flash[:info] = "Please Sign In."
      redirect_to login_url
    end
  end

  # save each of the tags with the @bookmark.id
  def save_tags(tag_str)
    tag_str.each do |t| 
      Tag.create(name: t, bookmark_id: @bookmark.id)
    end
  end

  def set_tags(tag_str)
    tag_str.split(%r{,\s*})
  end

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bookmark_params
    params.require(:bookmark).permit(:url, :title, :private, :desc, :is_archived, :hashed_url)
  end
end
