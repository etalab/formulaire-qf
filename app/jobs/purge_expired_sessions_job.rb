class PurgeExpiredSessionsJob < ApplicationJob
  queue_as :default

  def perform
    ActiveRecord::SessionStore::Session.where(updated_at: ...23.hours.ago).delete_all
  end
end
