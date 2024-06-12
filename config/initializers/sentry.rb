Sentry.init do |config|
  config.dsn = Settings.sentry.dsn
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.enabled_environments = %w[production staging sandbox]
  config.traces_sample_rate = 1.0
end
