class Tag < ActiveRecord::Base
  belongs_to :bookmark
  attr_accessible :name
  validates_presence_of :name, :on => :create
end
