module DashboardsHelper
  def activity_title(activity)
    resource      = activity.resource
    path          = resource.is_a?(User) ? user_profile_path(resource) : polymorphic_path(resource)
    resource_link = link_to(resource.name, path, { class: 'text-sm text-cyan-600' })

    "#{activity.title} #{resource_link}".html_safe
  end
end
