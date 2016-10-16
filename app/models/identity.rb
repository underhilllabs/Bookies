class Identity < OmniAuth::Identity::Models::ActiveRecord
  #attr_accessible :email, :username, :nickname, :name, :password, :password_confirmation
  # validates_presence_of :username
  validates_uniqueness_of :email
  # recommend use: /\A .. \z/ in regexp instead of /^ .. $/ the 2nd doesn't match newlines
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$\z/i
end


