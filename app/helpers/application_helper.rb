module ApplicationHelper
  def avatar(user, size:)
    size ||= 10
    styles = "h-#{size} w-#{size} rounded-full"

    if user.avatar.attached?
      image_tag user.avatar.variant(resize: "#{size}x#{size}!"), class: styles
    else
      # NOTE: we default to gravatar which will return a default image if the user doesn't have an account
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
      image_tag gravatar_url, alt: user.display_name, class: styles
    end
  end
end
