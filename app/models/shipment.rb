class Shipment < ApplicationRecord
  enum hubee_status: {pending: "pending", in_progress: "in_progress", done: "done", refused: "refused"}
  validates :reference, presence: true
end
