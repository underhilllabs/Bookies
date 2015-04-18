class BookmarkArchiver
  @@archive_tags = %w[div figure p ul li ol pre img a h1 h2 h3 h4 h5]
  @@archive_attributes = %w[src href width height]

  @queue = :bookmark_archive_queue
  def self.perform(bookmark_id)
    b = Bookmark.find(bookmark_id)
    mechanize = Mechanize.new
    source = mechanize.get(b.url).body
    File.open("public/archive/#{b.id}.html", "w") do |f|
      #logger.info "archiving ID: #{b.id}"
      f.write("<h1>#{b.title}</h1>\n<hr />\n")
      f.write(Readability::Document.new( source, :tags => @@archive_tags, :attributes => @@archive_attributes ).content)
      b.is_archived = true
      b.archive_url = "/archive/#{b.id}.html"
      b.save
    end
  end
end
