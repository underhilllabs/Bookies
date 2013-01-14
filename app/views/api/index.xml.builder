xml.instruct! :xml, version: "1.0" 
xml.posts do 
  @bookmarks.each do |bookmark|
    xml.post(:href => bookmark.url,:description => bookmark.title, :extended => bookmark.desc, :hash => bookmark.hashed_url, :tag => bookmark.tags.join(" ") ,:time => bookmark.updated_at )
  end
end
