Settings.add_source!(credentials: Rails.application.credentials.to_h)
Settings.reload!
