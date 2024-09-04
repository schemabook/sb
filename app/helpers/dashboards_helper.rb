module DashboardsHelper
  def activity_title(activity)
    resource = activity.resource

    case resource.class.to_s
    when "Version"
      "#{activity.title} on #{resource_link(activity)}".html_safe
    when "Webhook"
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
           when "Webhook"
             schema_path(resource.schema, { webhook: resource.index })
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

  def sortable_table_header(title, column, path_method, attrs)
    content_tag(:th, attrs) do
      sortable_column(title, column, path_method)
    end
  end

  def sortable_column(title, column, path_method)
    direction = column.to_s == params[:sort].to_s && params[:direction] == "asc" ? "desc" : "asc"

    query_params = request.query_parameters.merge(sort: column, direction:)

    path = send(path_method, query_params)
    link_to(path) do
      concat title
      concat sort_icon(column)
    end
  end

  def sort_icon(column)
    return unless params[:sort].to_s == column.to_s

    if params[:direction] == "asc"
      svg_icon("M5 15l7-7 7 7")
    else
      svg_icon("M19 9l-7 7-7-7")
    end
  end

  def svg_icon(path_d)
    content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "ml-1 inline w-4 h-4", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
      "<path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='#{path_d}'></path>".html_safe
    end
  end
end
