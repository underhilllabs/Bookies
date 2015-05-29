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

  def bookmark_archive_link(b)
    if /html/.match(b.archive_url)
      archive_bookmark_path(b)
    else
      b.archive_url
    end
  end
end
