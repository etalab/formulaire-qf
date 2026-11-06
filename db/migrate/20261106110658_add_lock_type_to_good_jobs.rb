# frozen_string_literal: true

class AddLockTypeToGoodJobs < ActiveRecord::Migration[8.1]
  def change
    add_column :good_jobs, :lock_type, :integer, limit: 2, if_not_exists: true
  end
end
