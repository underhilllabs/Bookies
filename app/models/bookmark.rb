class Bookmark < ApplicationRecord
  before_save :hash_url
  belongs_to :user
  has_one :archive
  acts_as_taggable

  validates_presence_of :url, :title, :user_id

  # Set default order: most recently updated
  default_scope { order('updated_at DESC') }
  scope :published, -> { where(private: :nil) }
  scope :my_bookmarks, ->(user_id) { where(user_id: user_id) }
  # scope :published_or_mine,->(user_id) find_by_sql(.. UNION ..)
  scope :unpublished, -> { where(private: true) }
  scope :archived, -> { where(is_archived: true) }

  # download and archive the bookmark
  def archive_the_url
    if is_archived?
      logger.info "Queued the archiving of the url with id: #{id}"
      Resque.enqueue(BookmarkArchiver, id)
    end
  end
  private
 
  def hash_url
    self.hashed_url = Digest::MD5.hexdigest(url)
  end
end
