Rails.application.configure do
  config.good_job.dashboard_default_locale = :fr
  config.good_job.enable_cron = ENV["FRONTAL"] == "true"
  config.good_job.cron = {
    populate_hubee_sandbox: {cron: "10 4 * * *", class: "PopulateHubEESandboxJob"},
    process_hubee_notifications: {cron: "10 */4 * * *", class: "ReadHubEENotificationsJob"},
  }
end

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(Settings.good_job.username, username) &
    ActiveSupport::SecurityUtils.secure_compare(Settings.good_job.password, password)
end
