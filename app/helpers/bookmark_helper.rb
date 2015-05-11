module BookmarkHelper
  include ActsAsTaggableOn::TagsHelper
  def add_bookmark(href, desc, extended, tags, time, hashed_url )
    @Bookmark = Bookmark.new
    @Bookmark.user_id = session[:user_id]
    @Bookmark.url = href
    @Bookmark.title = desc
    @Bookmark.created_at = Time.now
    @Bookmark.hashed_url = Digest::MD5.hexdigest(href)
    @Bookmark.save
  end
end
