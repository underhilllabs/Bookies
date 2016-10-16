class User < ActiveRecord::Base
  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable
  # include DeviseTokenAuth::Concerns::User
  #attr_accessible :desc, :email, :fullname, :pic_url, :username, :website, :website2, :website3, :password, :password_confirmation
  acts_as_tagger
  # has_secure_password
  has_many :bookmarks, :dependent => :destroy
  has_many :old_tags
  has_many :archives
  #has_many :followings, :dependent => :destroy 
  # validates_presence_of :password, :on => :create
  #validates :email, :presence => true, :uniqueness => true
  validates :username, :presence => true, length: { minimum: 2} 
  validates :api_token, presence: true, uniqueness: true
  before_validation :generate_api_token

  #validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def self.from_omniauth(auth)
    auth ||= {}
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
  def generate_api_token
    return if api_token.present?

    loop do
      self.api_token = SecureRandom.hex
      break unless User.exists? api_token: api_token
    end
  end

  # handle_asynchronously with delayed_job
  def regenerate_api_token
    loop do
      self.api_token = SecureRandom.hex
      break unless User.exists? api_token: api_token
    end
  end
end
