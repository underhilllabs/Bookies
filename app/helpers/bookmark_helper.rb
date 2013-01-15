module BookmarkHelper
  def add_bookmark(href, desc, extended, tags, time, hashed_url )
    @Bookmark = Bookmark.new
    @Bookmark.url = href
    @Bookmark.title = desc
    @Bookmark.created_at = Time.now
    @Bookmark.hashed_url = Digest::MD5.hexdigest(href)
  end
end
