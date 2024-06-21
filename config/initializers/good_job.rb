Rails.application.configure do
  config.good_job.dashboard_default_locale = :fr
  config.good_job.enable_cron = true
  config.good_job.cron = {
    populate_hubee_sandbox: {cron: "0 4 * * *", class: "PopulateHubEESandboxJob"},
  }
end

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(Settings.good_job.username, username) &
    ActiveSupport::SecurityUtils.secure_compare(Settings.good_job.password, password)
end
