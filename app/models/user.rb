class User < ActiveRecord::Base
  attr_accessible :desc, :email, :fullname, :password_digest, :pic_url, :username, :website, :website2, :website3, :password, :password_confirmation
  has_secure_password
  has_many :bookmarks, :dependent => :destroy
  has_many :tags
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :presence => true, :uniqueness => true, :email_format => true
  validates_presence_of :username
end
