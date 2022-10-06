module DashboardsHelper
  def activity_title(activity)
    resource = activity.resource

    case resource.class.to_s
    when "Version"
      "#{activity.title} on #{resource_link(activity)}".html_safe
    else
      "#{activity.title} #{resource_link(activity)}".html_safe
    end
  end

  def resource_link(activity)
    resource = activity.resource

    path = case resource.class.to_s
           when "Version"
             schema_path(resource.schema, { version: resource.index })
           when "User"
             user_profile_path(resource)
           else
             polymorphic_path(resource)
           end

    link_to(truncate(resource.name, length: 30), path, { class: 'text-sm text-cyan-600' })
  end

  def activity_content(activity)
    user = activity.user

    detail = case activity.title
             when "Created Comment" || "Comment Created"
               "by #{user.display_name}"
             else
               truncate(activity.detail, length: 30)
             end

    detail.html_safe
  end

  def small_avatar(user, add_styles = nil)
    size = 5
    styles = "inline-block h-#{size} w-#{size} rounded-full ring-2 ring-white "
    styles += add_styles

    if user.avatar.attached?
      image_tag user.avatar.variant(resize: "#{size}x#{size}!"), class: styles
    else
      # NOTE: we default to gravatar which will return a default image if the user doesn't have an account
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
      image_tag gravatar_url, alt: user.display_name, class: styles
    end
  end

  def stakeholders(stakeholders)
    results = ""
    stakeholders.each_with_index do |stakeholder, index|
      add_styles = ""
      add_styles += "-ml-1" if index.positive?

      results += small_avatar(stakeholder.user, add_styles)
    end

    results.html_safe
  end
end
