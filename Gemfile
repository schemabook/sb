source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1.5.1"
# Use postgres
gem "pg"
# Use pg_query for SQL validation
gem "pg_query"
# Use Puma as the app server
gem "puma", ">= 6"
# Rails 7 declares optional dependency, app was started in v 6 and needs this
gem "sprockets-rails"
# Ruby 3.1 uses Psych 4 which changes how YAML is loaded
gem "psych", "> 4"
# js build pipeline (uses webpack)
gem "jsbundling-rails"
# Use tailwind CSS framework
gem "tailwindcss-rails", "~> 2.6.4"
# turbo
gem "turbo-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Devise for Authentication
gem "devise"
# Use Devise invitable for inviting team members
gem "devise_invitable", "~> 2.0.9"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.12.2'

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', '>= 1.4.4', require: false

# used to send email from Render
gem "mailgun-ruby", "~>1.2.5"

# avro gems
gem "avro"
gem "avro-builder"

# json gem
gem "json-schema"

# csv support
gem "csv"

# for avatars
gem "image_processing"

# nanoid generator for schema slugs
gem "nanoid"

# rswag gems for API docs
gem "rswag-api"
gem "rswag-ui"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# API
gem "grape"
gem "grape-entity"

# betterstack
gem "logtail-rails", "~> 0.2.6"

# for payments
gem "stripe", "~> 10.2"

# for pagination
gem "kaminari"

gem "markdown-rails", "~> 2.1"

gem "rouge", "~> 4.3"

gem "httparty"

# for bots
gem 'rails_cloudflare_turnstile'

group :development, :test do
  # Use rspec  instead of test-unit
  gem "rspec-rails", "~> 6.1.1"
  gem "rswag-specs"
  # Use Pry bindings
  gem "pry"
  gem "pry-rails"
  # Use rubocop for linting
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  # audit gems
  gem "bundler-audit"
  # check for vulns
  gem "brakeman"
end

group :development do
  gem "letter_opener"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 4.0"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
  # test coverage
  gem "simplecov", require: false
end
