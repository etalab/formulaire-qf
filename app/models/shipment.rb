class Shipment < ApplicationRecord
  enum :hubee_status, {pending: "pending", sent: "sent", si_received: "si_received", in_progress: "in_progress", done: "done", refused: "refused"}
  validates :reference, presence: true, uniqueness: true, length: {is: 13}
  validates_presence_of :hubee_case_id, :hubee_folder_id
  after_initialize :affect_reference

  belongs_to :collectivity

  def affect_reference
    return if persisted?
    reference = SecureRandom.hex[0...13].upcase

    if Shipment.where(reference: reference).any?
      affect_reference
    else
      self.reference = reference
    end
  end
end
