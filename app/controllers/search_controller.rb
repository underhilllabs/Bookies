class SearchController < ApplicationController
  respond_to :html, :json

  def index
    @bookmarks = Bookmark.where("title like ?", "%#{params[:keywords]}%") unless params[:keywords].nil?
    @keywords = params[:keywords]
    respond_with @bookmarks
  end

end
