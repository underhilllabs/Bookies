class BookmarksController < ApplicationController
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

    if @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title], 
                                   :desc => params[:bookmark][:desc], :private => params[:bookmark][:private],
                                   :is_archived => params[:bookmark][:is_archived],
                                   :hashed_url => Digest::MD5.hexdigest(params[:bookmark][:url]) )
      # now delete tags not passed in
      t_missing = Tag.where("bookmark_id = ?", @bookmark.id).where("name not in (?)", tags_arr).pluck(:id)
      Tag.destroy(t_missing)
      
      flash[:notice] = "\"#{@bookmark.title}\" was successfully updated."
    end
    @bookmark.archive_the_url if params[:bookmark][:is_archived]

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
    tags = []
    tag_str = set_tags(params[:bookmark][:tags])
    tag_str.each do |tag|
      tags << Tag.new(:name => tag)
    end
    # use find_or_create
    @bookmark = Bookmark.where(:url => params[:bookmark][:url], :title => params[:bookmark][:title], :desc => params[:bookmark][:desc], :is_archived => params[:bookmark][:is_archived], :private => params[:bookmark][:private], :user_id => params[:bookmark][:user_id], :hashed_url => Digest::MD5.hexdigest(params[:bookmark][:url]) ).first_or_create 
    # archive the url if checked
    @bookmark.archive_the_url if params[:bookmark][:is_archived]
    
    respond_to do |format|
      if @bookmark.save
        # add bookmark id to each tag we created
        tags.each { |t| t.bookmark_id = @bookmark.id; t.save}
        if params[:bookmark][:is_popup]
          format.html { redirect_to(@bookmark, :notice => 'Close the Window!', :locals => {:close_window => 1}) }
        else  
          format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully created.') }
          format.xml  { render :xml => @bookmark, :status => :created, :location => @bookmark }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
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
  def set_tags(tag_str)
    tag_str.split(%r{,\s*})
  end

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bookmark_params
    params.require(:bookmark).permit(:url, :title, :desc, :is_archived, :hashed_url)
  end
end
