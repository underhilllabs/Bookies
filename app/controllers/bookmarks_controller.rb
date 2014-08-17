class BookmarksController < ApplicationController
  respond_to :html, :json, :xml, :rss

  def update
    # TODO: make this controller thinner!
    @bookmark = Bookmark.find(params[:id])
    tag_s = params[:bookmark][:tags].split(',').map do |tag|
      tag.strip
    end
    tag_s.each do |tag|
      Tag.where(:name => tag, :bookmark_id => params[:id]).first_or_create
    end
    
    # check if user has permission to edit bookmark
    if session[:user_id] != @bookmark.user_id
      flash[:error] = "Sorry, you do not have permission to edit another user's bookmarks!"
      redirect_to root_url
    end

    if @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title], 
                                   :desc => params[:bookmark][:desc], :private => params[:bookmark][:private],
                                   :hashed_url => Digest::MD5.hexdigest(params[:bookmark][:url]) )
      # now delete tags not passed in
      t_missing = Tag.where("bookmark_id = ?", @bookmark.id).where("name not in (?)", tag_s).pluck(:id)
      Tag.destroy(t_missing)
      
      flash[:notice] = "\"#{@bookmark.title}\" was successfully updated."
    end

    redirect_to root_url
  end


  def user
    @user = User.find(params[:id])
    # FIXME TODO
    if current_user && current_user.id.to_s == params[:id] 
      @bookmarks = Bookmark.where(:user_id => params[:id]).order("updated_at DESC").page(params[:page]).per_page(20)
    else
      @bookmarks = Bookmark.where(:user_id => params[:id]).order("updated_at DESC").where(:private => nil).page(params[:page]).per_page(20)
    end
    respond_with @bookmarks
  end


  def show
    @bookmark = Bookmark.find(params[:id])
    
    respond_with @bookmark
  end

  # GET /bookmarks
  # GET /bookmarks.xml
  def index
    if params[:not_tags] then
      not_tags = params[:not_tags].split("+")
      @bookmarks = Bookmark.where.not(tags: not_tags).order(updated_at: :desc).page(params[:page]).per_page(20)
    else 
      @bookmarks = Bookmark.order("updated_at DESC").page(params[:page]).per_page(20)
    end

    respond_with @bookmarks
  end
  
  def user_bookmarks
    #@user = current_user
    #@bookmarks = @user.bookmarks.order("updated_at DESC")
    @bookmarks = Bookmark.order("updated_at DESC").where(:user_id => current_user.id)

    respond_with @bookmarks
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    tags = params[:bookmark][:tags].split(',').map do |tag|
      Tag.new(:name => tag.strip)
    end
    # use find_or_create
    @bookmark = Bookmark.where(:url => params[:bookmark][:url], :title => params[:bookmark][:title], :desc => params[:bookmark][:desc], :private => params[:bookmark][:private], :user_id => params[:bookmark][:user_id], :hashed_url => Digest::MD5.hexdigest(params[:bookmark][:url]) ).first_or_create
    
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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @bookmark = Bookmark.find(params[:id])
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def bookmarklet
    # @bookmark = Bookmark.new(:tags => [Tag.new])
    @bookmark = Bookmark.where(:url => params[:address], :user_id => session[:user_id]).first_or_initialize()
    respond_to do |format|
      format.html # bookmarklet.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end



  def search
    @bookmarks = Bookmark.find(:all, "test")
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end
  

  # get /bookmarks/:id/edit
  def edit
    @bookmark = Bookmark.find(params[:id])
    @tags = @bookmark.tags
    if session[:user_id] == @bookmark.user_id
      respond_with @bookmark
    else 
      flash[:error] = "Sorry, you do not have permissions to edit Bookmark!"
      redirect_to root_url
    end
  end
end
