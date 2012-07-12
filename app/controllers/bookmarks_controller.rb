class BookmarksController < ApplicationController
  respond_to :html, :json, :xml, :rss

  def update
    @bookmark = Bookmark.find(params[:id])
    tag_s = params[:bookmark][:tags].split(',').map do |tag|
      tag.strip
    end
    tags = tag_s.each do |tag|
      Tag.find_or_create_by_name_and_bookmark_id(:name => tag, :bookmark_id => params[:id])
    end

    if @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title], 
                                   :desc => params[:bookmark][:desc], :private => params[:bookmark][:private])
      # now delete tags not passed in
      t_missing = Tag.where("bookmark_id = ?", @bookmark.id).where("name not in (?)", tag_s).pluck(:id)
      Tag.destroy(t_missing)
      
      flash[:notice] = "Bookmark was successfully updated."
    end

    respond_with @bookmark
  end


  def user
    @user = User.find(params[:id])
    # FIXME TODO
    if session[:user_id] == params[:id] 
      @bookmarks = Bookmark.where(:user_id => params[:id]).page(params[:page]).per_page(10)
    else
      @bookmarks = Bookmark.where(:user_id => params[:id]).where(:private => false).page(params[:page]).per_page(10)
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
    @bookmarks = Bookmark.order("updated_at DESC").page(params[:page]).per_page(10)

    respond_with @bookmarks
  end
  
  def user_bookmarks
    @bookmarks = Bookmark.find(:all, :conditions => {:user_id => session[:user_id]} )

    respond_with @bookmarks
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    tags = params[:bookmark][:tags].split(',').map do |tag|
      Tag.new(:name => tag.strip)
    end
    # use find_or_create
    @bookmark = Bookmark.find_or_create_by_user_id_and_url(:url => params[:bookmark][:url], :title => params[:bookmark][:title], :desc => params[:bookmark][:desc], :private => params[:bookmark][:private], :user_id => params[:bookmark][:user_id])
    
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
    @bookmark.destroy
    # added these 2 lines because tags are not getting deleted!
    # title = @bookmark.title
    # Bookmark.destroy(params[:id])
    # @bookmark.destroy

    redirect_to root_url, :notice => "#{@bookmark.title} was deleted!"
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def new
    @bookmark = Bookmark.new(:tags => [Tag.new])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.xml
  def bookmarklet
    # @bookmark = Bookmark.new(:tags => [Tag.new])
    @bookmark = Bookmark.where(:url => params[:address], :user_id => session[:user_id]).first_or_initialize(:tags => [Tag.new])
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
  

  def edit
    @bookmark = Bookmark.find(params[:id])
    if session[:user_id] == @bookmark.user_id
      respond_with @bookmark
    else 
      redirect_to root_url, :notice => "Sorry, you do not have permissions to edit Bookmark!"
    end
  end
end
