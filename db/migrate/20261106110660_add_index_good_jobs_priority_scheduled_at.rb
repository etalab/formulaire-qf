# frozen_string_literal: true

class AddIndexGoodJobsPriorityScheduledAt < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :good_jobs, [:priority, :scheduled_at, :id],
      where: "finished_at IS NULL", name: "index_good_jobs_on_priority_scheduled_at_unfinished",
      algorithm: :concurrently, if_not_exists: true
    add_index :good_jobs, [:queue_name, :scheduled_at, :id],
      where: "finished_at IS NULL", name: "index_good_jobs_on_queue_name_priority_scheduled_at_unfinished",
      algorithm: :concurrently, if_not_exists: true
  end
end
