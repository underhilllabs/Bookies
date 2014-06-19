xml.instruct! :xml, version: "1.0" 
xml.posts(:user => @user.username) do 
  @bookmarks.each do |bookmark|
    xml.post(:href => bookmark.url,:description => bookmark.title, :extended => bookmark.desc, :hash => bookmark.hashed_url, :tag => bookmark.tags.to_a.join(" "), :time => bookmark.updated_at.strftime('%Y-%m-%dT%H-%M-%SZ'))
  end
end
