source "https://rubygems.org"

ruby "3.4.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
gem "prawn"
gem "rqrcode", "~> 3.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "rails-i18n", "~> 8.0.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "config"
gem "omniauth_openid_connect"
gem "hash_mapper"
gem "omniauth-rails_csrf_protection"
gem "interactor", "~> 3.0"
gem "sentry-ruby"
gem "sentry-rails"
gem "factory_bot_rails"
gem "active_model_serializers", github: "rails-api/active_model_serializers", branch: "0-10-stable"
gem "activerecord-session_store"

gem "faraday"
gem "faraday-gzip"
gem "faraday-net_http"
gem "faraday-retry"
gem "faraday-encoding"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 8.0.1"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "standard", "~> 1.50", require: false
  gem "rubocop-rails", require: false

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
  gem "spring-commands-rspec"
  gem "brakeman"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "cucumber-rails", require: false, github: "tagliala/cucumber-rails", branch: "feature/589-rails-8"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
  gem "webmock"
  gem "simplecov", require: false
  gem "shoulda-matchers", "~> 6.5"
  gem "guard"
  gem "guard-cucumber"
  gem "guard-rspec"
  gem "timecop"
end

gem "good_job", "~> 3.99"

gem "rack-cors"
