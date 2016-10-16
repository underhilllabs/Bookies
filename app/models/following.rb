class Following < ActiveRecord::Base
  #attr_accessible :following_id, :user_id
  belongs_to :user_id
  validates_presence_of :user_id
  validates_presence_of :following_id
end
