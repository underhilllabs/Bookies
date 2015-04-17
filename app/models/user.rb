class User < ActiveRecord::Base
  attr_accessible :desc, :email, :fullname, :pic_url, :username, :website, :website2, :website3, :password, :password_confirmation
  # has_secure_password
  has_many :bookmarks, :dependent => :destroy
  has_many :tags
  has_many :followings, :dependent => :destroy 
  # validates_presence_of :password, :on => :create
  validates_presence_of :email, :presence => true, :uniqueness => true, :email_format => true
  validates_presence_of :username

  def self.from_omniauth(auth)
    where(:provider => auth[:provider], :uid => auth[:uid]).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      if user.provider == "twitter"
        user.email = "fake@fail.edu"
        user.pic_url = auth["info"]["image"]
      else 
        user.email = auth["info"]["email"]
      end

    end
  end

  # import bookmarks files to users account 
  def import_bookmarks(xml)
    doc = Nokogiri.XML(xml)
    doc.xpath('/posts/post').map do |p|
      time = Time.parse(p["time"])
      b = Bookmark.where(:url => p["href"], :title => p["description"], :desc => p["extended"], :user_id => id, :hashed_url => p["hash"], :created_at => time, :updated_at => time ).first_or_create
      if p["tag"] then
        tags = p["tag"]
        tags = tags.split(" ").map do |tag|
          Tag.new(:name => tag.strip)
        end
        if b.save then
          tags.each { |t| t.bookmark_id = b.id; t.save }
        end
      else
        b.save
      end
    end
  end

  # handle_asynchronously with delayed_job
  #handle_asynchronously :import_bookmarks

end
