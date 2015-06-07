module ApplicationHelper
  def avatar_url(user, img_size=80)
    if user.provider == "twitter"
      # user.pic_url if user.pic_url?
    else 
      user.email ||= "fake@fail.edu"
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{APP_CONFIG["gravatar_type"]}&s=#{img_size}" 
    end
  end
  
  def avatar_url_from_id(user_id, img_size=80)
    if user_id.nil?
      return ""
    end
    @user = User.find(user_id)
    if @user.provider == "twitter" 
      # @user.pic_url
    else 
      @user.email ||= "fake@fake.edu"
      gravatar_id = Digest::MD5::hexdigest(@user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{APP_CONFIG["gravatar_type"]}&s=#{img_size}"
    end
  end


  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def nice_date_form(the_date)
    return the_date.strftime('%B %e, %Y')
  end

  def cloud_tags(cutoff, user)
    @tags = Tag.group("name").having("count(name) > :cutoff", :cutoff => cutoff).order("count(name) DESC").count()
  end
end
