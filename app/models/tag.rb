class Tag < ActiveRecord::Base
  belongs_to :bookmark
  belongs_to :user
  attr_accessible :name, :bookmark_id
  validates_presence_of :name, :on => :create
  # so you can do: @bookmark.tags.join(", ")
  def to_s
    "#{name}"
  end
end
