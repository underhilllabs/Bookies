class BookmarkArchiver
  @@archive_tags = %w[div figure p ul li ol pre img a h1 h2 h3 h4 h5]
  @@archive_attributes = %w[src href width height]

  @queue = :bookmark_archive_queue
  def self.perform(bookmark_id)
    b = Bookmark.find(bookmark_id)
    mechanize = Mechanize.new
    page = mechanize.get(b.url)
    source = page.body
    fname = page.filename
    if /(pdf|png|jpg|gif|gifv)$/.match(fname) then
      ext = /(pdf|png|jpg|gif|gifv)$/.match(fname)[1]
      File.open("public/archive/#{b.id}.#{ext}", "wb") do |f|
        f.write(source)
      end
    else
      ext = "html"
      File.open("public/archive/#{b.id}.html", "w") do |f|
        f.write("<h1>#{b.title}</h1>\n<hr />\n")
        f.write(Readability::Document.new( source, :tags => @@archive_tags, :attributes => @@archive_attributes ).content)
      end
    end
    Archive.find_or_create_by(bookmark_id: b.id, location: b.archive_url, user_id: b.user_id, url: b.url, filetype: ext)
    b.is_archived = true
    b.archive_url = "/archive/#{b.id}.#{ext}"
    b.save
  end
  
  def save_web_file(b)
    source = mechanize.get(b.url).body
    File.open("public/archive/#{b.id}.html", "w") do |f|
      f.write("<h1>#{b.title}</h1>\n<hr />\n")
      f.write(Readability::Document.new( source, :tags => @@archive_tags, :attributes => @@archive_attributes ).content)
      b.is_archived = true
      b.archive_url = "/archive/#{b.id}.html"
      Archive.find_or_create_by(bookmark_id: b.id, location: b.archive_url, user_id: b.user_id, url: b.url)
      b.save
    end
  end

  def save_binary_file(b)
    source = mechanize.get(b.url).body
    File.open("public/archive/#{b.id}.html", "w") do |f|
      Archive.find_or_create_by(bookmark_id: b.id, location: b.archive_url, user_id: b.user_id, url: b.url)
    end
  end
end
