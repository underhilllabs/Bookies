class BookmarksController < ApplicationController
  respond_to :html, :json

  def update
    @bookmark = Bookmark.find(params[:id])
    ts = []
    tags = []
    # split tags parameter and create a new Tag for each
    tag_s = params[:bookmark][:tags].split(',')
    # remove whitespace
    tag_s.map!(&:strip)
    # for each tag, if there isn't a tag that is associated with bookmark, then create it.
    # TODO need to loop thru and remove tags that are not in this list
    tag_s.each do |t| 
      unless t.nil?
        tag = Tag.where("name = ?", t).where("bookmark_id = ?", params[:id]).first
        if tag.nil?
          tn =  Tag.new(:name => t)
          tn.bookmark_id = params[:id]
          tn.save
          tags << tn
        else 
          tags << tag
        end
      end
    end
    
    # @bookmark = Bookmark.new(
    # @bookmark = Bookmark.update_attributes(params[:bookmark])
    


    if @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title], :desc => params[:bookmark][:desc], :private => params[:bookmark][:private])
      tags.each {|t| t.bookmark_id = @bookmark.id }
      # now delete tags not passed in
      t_missing = Tag.where("name not in (?)", tag_s)
      Tag.destroy(t_missing.map(&:id))
      
      flash[:notice] = "Bookmark was successfully updated."
    end

    respond_with @bookmark
  end

  def show
    @bookmark = Bookmark.find(params[:id])
    
    respond_with @bookmark
  end

  # GET /bookmarks
  # GET /bookmarks.xml
  def index
    @bookmarks = Bookmark.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bookmarks }
      format.json  { render :json => @bookmarks }
    end
  end
  
  def user_bookmarks
    @bookmarks = Bookmark.find(:all, :conditions => {:user_id => session[:user_id]} )

    respond_to do |format|
      format.html # user_bookmarks.html.erb
      format.xml  { render :xml => @bookmarks }
      format.json  { render :json => @bookmarks }
    end
  end

  # POST /bookmarks
  # POST /bookmarks.xml
  def create
    ts = []
    tags = []
    # split tags parameter and create a new Tag for each
    ts = params[:bookmark][:tags].split(',')
    ts.each do |t| 
      unless t.nil?
        tags << Tag.new(:name => t.strip) 
      end
    end

    @bookmark = Bookmark.new(:url => params[:bookmark][:url], :title => params[:bookmark][:title], :desc => params[:bookmark][:desc],
                             :private => params[:bookmark][:private])
    
    respond_to do |format|
      if @bookmark.save
        # add bookmark id to each tag we created
        tags.each { |t| t.bookmark_id = @bookmark.id; t.save}
        format.html { redirect_to(@bookmark, :notice => 'Bookmark was successfully created.') }
        format.xml  { render :xml => @bookmark, :status => :created, :location => @bookmark }
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


  def search
    @bookmarks = Bookmark.find(:all, "test")
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bookmark }
    end
  end
  
  def edit
    @bookmark = Bookmark.find(params[:id])
  end
end
