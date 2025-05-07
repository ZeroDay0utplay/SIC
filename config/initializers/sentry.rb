Sentry.init do |config|
  config.dsn = 'https://79358c5fbcff74e73bf42fde212d57f0@o4508652846383104.ingest.de.sentry.io/4508652848087120'

  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.enabled_environments = %w[production]

  config.send_default_pii = true
end
