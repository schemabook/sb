Rails.application.reloader.to_prepare do
  # Autoload classes and modules needed at boot time here.

  # Businesses created
  Subscribers::Businesses::Created::ActivityLog.new

  # Services created
  Subscribers::Services::Created::Activity.new

  # Schemas created
  Subscribers::Schemas::Created::Activity.new
end
