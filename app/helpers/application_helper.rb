module ApplicationHelper
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=monsterid"
  end
  
  def avatar_url_from_id(user_id)
    if user_id.nil?
      return ""
    end
    @user = User.find(user_id)
    gravatar_id = Digest::MD5::hexdigest(@user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=monsterid"
  end

  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def nice_date_form(the_date)
    return the_date.strftime('%B %e, %Y')
  end
end
