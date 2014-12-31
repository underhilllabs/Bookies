class Bookmark < ActiveRecord::Base
  attr_accessible :desc, :private, :title, :url, :user_id, :tags, :hashed_url, :is_archived, :archive_url
  belongs_to :user
  has_many :tags, :dependent => :destroy

  validates_presence_of :url, :on => :create
  validates_presence_of :title, :on => :create
  validates :user_id, :presence => true

  scope :published, -> { where(private: :nil) }
  scope :unpublished, -> { where(private: true) }
  scope :archived, -> { where(is_archived: true) }

  # archive the bookmark with readability
  # archive url: /archive/#{bookmark_id}
  def archive_url
    mechanize = Mechanize.new
    source = mechanize.get(url).body
    File.open("public/archive/#{id}.html", "w") do |f|
      f.write(Readability::Document.new(source).content)
    end
    is_archived = True
    archive_url = "/archive/#{id}.html"
  end

  handle_asynchronously :archive_url
end
