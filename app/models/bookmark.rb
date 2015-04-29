class Bookmark < ActiveRecord::Base
  attr_accessible :desc, :private, :title, :url, :user_id, :tags, :hashed_url, :is_archived, :archive_url
  belongs_to :user
  has_many :tags, :dependent => :destroy

  validates_presence_of :url, :presence => true
  validates_presence_of :title, :presence => true
  validates :user_id, :presence => true

  scope :published, -> { where(private: :nil) }
  scope :my_bookmarks, ->(user_id) { where(user_id: user_id) }
  # scope :published_or_mine,->(user_id) find_by_sql(.. UNION ..)
  scope :unpublished, -> { where(private: true) }
  scope :archived, -> { where(is_archived: true) }

  # download and archive the bookmark
  def archive_the_url
    logger.info "Queued the archiving of the url"
    Resque.enqueue(BookmarkArchiver, id)
  end
end
