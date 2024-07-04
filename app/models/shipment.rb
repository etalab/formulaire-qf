class Shipment < ApplicationRecord
  enum hubee_status: {pending: "pending", in_progress: "in_progress", done: "done", refused: "refused"}
  validates :reference, presence: true, uniqueness: true, length: {is: 13}
  after_initialize :affect_reference

  def affect_reference
    return if persisted?
    reference = SecureRandom.hex[0...13].upcase

    if Shipment.find_by(reference: reference).present?
      affect_reference
    else
      self.reference = reference
    end
  end
end
