if Rails.env.production?
  Mailgun.configure do |config|
    config.api_key = ENV['mailgun-api-key']
  end
end
