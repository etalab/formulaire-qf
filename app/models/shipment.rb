class Shipment < ApplicationRecord
  enum hubee_status: {pending: "pending", in_progress: "in_progress", done: "done", refused: "refused"}
  validates :reference, presence: true, uniqueness: true

  def self.new_reference
    reference = SecureRandom.hex[0...13].upcase

    if Shipment.find_by(reference: reference).present?
      new_reference
    else
      reference
    end
  end
end
