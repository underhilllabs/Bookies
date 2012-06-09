class Tag < ActiveRecord::Base
  belongs_to :bookmark
  belongs_to :user
  attr_accessible :name
  validates_presence_of :name, :on => :create
end
