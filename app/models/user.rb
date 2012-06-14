class User < ActiveRecord::Base
  attr_accessible :desc, :email, :fullname, :password_digest, :pic_url, :username, :website, :website2, :website3, :password, :password_confirmation
  has_secure_password
  has_many :bookmarks, :dependent => :destroy
  has_many :tags
  # validates_presence_of :password, :on => :create
  validates_presence_of :email, :presence => true, :uniqueness => true, :email_format => true
  validates_presence_of :username

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.email = auth["info"]["email"]
    end
  end

end
