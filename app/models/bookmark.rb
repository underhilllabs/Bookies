class Bookmark < ActiveRecord::Base
  attr_accessible :desc, :private, :title, :url, :user_id, :tags_attributes, :tags
  belongs_to :user
  has_many :tags
  validates_presence_of :url, :on => :create
  validates_presence_of :title, :on => :create
  validates :user_id, :presence => true
end
