# Load the Rails application.
require_relative "application"

# use BetterStack logger
unless Rails.env.test?
  http_device = Logtail::LogDevices::HTTP.new(ENV.fetch("BETTERSTACK_TOKEN"))
  Rails.logger = Logtail::Logger.new(http_device)
end

# Initialize the Rails application.
Rails.application.initialize!
