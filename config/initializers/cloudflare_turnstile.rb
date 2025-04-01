RailsCloudflareTurnstile.configure do |c|
  c.site_key = ENV.fetch('CLOUDFLARE_SITE_KEY', nil)
  c.secret_key = ENV.fetch('CLOUDFLARE_SITE_SECRET', nil)
  c.fail_open = true
end
