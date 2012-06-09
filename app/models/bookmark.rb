class Bookmark < ActiveRecord::Base
  attr_accessible :desc, :private, :title, :url
  belongs_to :user
  has_many :tags
  validates_presence_of :url, :on => :create
  validates_presence_of :title, :on => :create
end
