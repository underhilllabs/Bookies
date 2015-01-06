class Bookmark < ActiveRecord::Base
  @@tags = %w[div p ul li ol pre img a h1 h2 h3 h4 h5]
  @@attributes = %w[src href width height]
  attr_accessible :desc, :private, :title, :url, :user_id, :tags, :hashed_url, :is_archived, :archive_url
  belongs_to :user
  has_many :tags, :dependent => :destroy

  validates_presence_of :url, :on => :create
  validates_presence_of :title, :on => :create
  validates :user_id, :presence => true

  scope :published, -> { where(private: :nil) }
  scope :unpublished, -> { where(private: true) }
  scope :archived, -> { where(is_archived: true) }

  # download and archive the bookmark
  def archive_the_url
    mechanize = Mechanize.new
    source = mechanize.get(url).body
    b = Bookmark.find(id)
    File.open("public/archive/#{id}.html", "w") do |f|
      f.write("<h1>#{title}</h1>\n<hr />\n")
      f.write(Readability::Document.new( source, tags: @@tags, attributes: @@attributes ).content)
      b.is_archived = true
      b.archive_url = "/archive/#{id}.html"
      b.save
    end
  end

  handle_asynchronously :archive_the_url
end
