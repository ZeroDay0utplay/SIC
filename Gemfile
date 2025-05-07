source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5", ">= 1.5.9"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
gem "turbolinks", "~> 5.2", ">= 5.2.1"

# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

gem "rails-controller-testing", group: :test

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
gem "inline_svg", "~> 1.9"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
gem "auto_strip_attributes"
gem "jquery-rails", "~> 4.6"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"
gem "devise", "~> 4.9", ">= 4.9.4"
gem "activestorage", "~> 8.0"
gem "ransack"
gem "image_processing", ">= 1.2"
gem "trix-rails"
gem "pagy"
gem "will_paginate"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem "active_model_serializers", "~> 0.10.15"
gem "rack-cors", "~> 2.0", ">= 2.0.2"

# Remove platform specific declaration for tzinfo-data
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "stackprof"
gem "geocoder", "~> 1.8", ">= 1.8.5"
gem "dotenv", "~> 3.1", ">= 3.1.7"
gem "cancancan"

# PDF
gem "wicked_pdf", "2.1.0"
gem "wkhtmltopdf-binary", "~> 0.12.6.8"

gem "draper"

# Monitoring
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "byebug"
  gem "faker"
  gem "pry", "~> 0.14.2"
  gem "letter_opener_web", "~> 3.0"
  gem "debug", platforms: [:mri] # Correction de la déclaration de plateforme
  gem "rspec", "~> 3.13"
  gem "rspec-its", "~> 1.3"
  gem "api_matchers", "~> 0.6.2"
  gem "shoulda-matchers", "~> 6.2"
  gem "database_cleaner", "~> 2.0", ">= 2.0.2"
  gem "simplecov", "~> 0.22.0"
  gem "rspec-rails", "~> 7.1"
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.4"
end

group :development do
  gem "foreman"
  gem "hotwire-livereload", github: "kirillplatonov/hotwire-livereload"
  gem "web-console"
  gem "bullet", "~> 8.0"
  # Lint ruby
  gem "standard"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
