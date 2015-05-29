class BookmarkImporter
  @queue = :bookmark_import_queue
  def self.perform(user_id, file_name)
    doc = Nokogiri.XML(file_name)
    doc.xpath('/posts/post').map do |p|
      time = Time.parse(p["time"])
      b = Bookmark.create_with(desc: p["extended"], url: p["href"], created_at: time, updated_at: time, title: p["description"]).find_or_create_by(:user_id => user_id, :hashed_url => p["hash"])
      if p["tag"] then
        tags = p["tag"]
        tags = tags.split(" ").map do |tag|
          Tag.new(:name => tag.strip)
        end
        if b.save then
          tags.each { |t| t.bookmark_id = b.id; t.save }
        end
      else
        b.save
      end
    end
  end
end
