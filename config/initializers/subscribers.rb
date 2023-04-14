Rails.application.reloader.to_prepare do
  # Autoload classes and modules needed at boot time here.

  # Businesses created
  Subscribers::Businesses::Created::ActivityLog.new
  Subscribers::Businesses::Created::WelcomeEmail.new

  # Businesses updated
  Subscribers::Businesses::Updated::Activity.new

  # Services created
  Subscribers::Services::Created::Activity.new
  Subscribers::Services::Created::EmailTeammates.new

  # Schemas created
  Subscribers::Schemas::Created::Activity.new

  # Invitation created
  Subscribers::Invitations::Created::Activity.new

  # Team created
  Subscribers::Teams::Created::Activity.new

  # Stakeholder created
  Subscribers::Stakeholders::Created::Activity.new

  # Comment created
  Subscribers::Comments::Created::Activity.new
  Subscribers::Comments::Created::Notifications.new

  # Version created
  Subscribers::Versions::Created::Activity.new
  Subscribers::Versions::Created::EmailStakeholders.new
end
