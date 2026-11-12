class SyncCollectivityStatusesJob < ApplicationJob
  queue_as :default

  def perform
    SyncCollectivityStatuses.call
  end
end
