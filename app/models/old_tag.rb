class OldTag < ActiveRecord::Base
  belongs_to :bookmark
  belongs_to :user
  attr_accessible :name, :bookmark_id
  validates_presence_of :name, :user_id, :bookmark_id

  # so you can do: @bookmark.tags.join(", ")
  def to_s
    "#{name}"
  end
end
