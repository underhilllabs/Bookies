class Archive < ActiveRecord::Base
  attr_accessible :user_id, :location, :bookmark_id, :url, :filetype
  belongs_to :bookmark
  belongs_to :user
end
