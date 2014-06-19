class ApiController < ApplicationController
  respond_to :xml, :html

  def import
    unless session[:user_id] then
      flash[:error] = "must be logged in"
      redirect_to root_url
    end
    myfile = params[:file]
    xml = myfile.read
    doc = Nokogiri.XML(xml)
    num_bs = 0
    doc.xpath('/posts/post').map do |p|
      b = Bookmark.new
      b.title = p["description"]
      b.url = p["href"]
      b.desc = p["extended"]
      b.user_id = session[:user_id]
      tags = p["tags"].split(" ").map do |tag|
          Tag.new(:name => tag.strip)
      end
      if b.save then
        tags.each { |t| t.bookmark = b; t.save }
      end
      num_bs += 1
    end
    num_lines = xml.split("\n").size
    flash[:notice] = "read in #{num_bs} bookmarks in #{num_lines} lines."
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
