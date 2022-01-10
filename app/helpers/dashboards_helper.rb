module DashboardsHelper
  def activity_title(activity)
    resource      = activity.resource
    resource_link = link_to(resource.name, polymorphic_path(resource), {class: 'text-sm text-cyan-600'})

    "#{activity.title} #{resource_link}".html_safe
  end
end
