class Bookmark < ActiveRecord::Base
  attr_accessible :desc, :private, :title, :url, :user_id, :tags, :hashed_url, :archived, :archive_url
  belongs_to :user
  has_many :tags, :dependent => :destroy

  validates_presence_of :url, :on => :create
  validates_presence_of :title, :on => :create
  validates :user_id, :presence => true

  scope :published, -> { where(private: :nil) }
  scope :unpublished, -> { where(private: true) }
end
