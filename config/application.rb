require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ideo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.default_locale = :fr

    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/models/material
      #{config.root}/app/models/planning
      #{config.root}/app/queries/helpers
    ]

    config.domain = ENV["APP_DOMAIN"] || Rails.application.credentials.domain
  end
end
