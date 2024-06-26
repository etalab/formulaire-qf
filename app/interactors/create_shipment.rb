class CreateShipment < BaseInteractor
  def call
    shipment = Shipment.new(params)
    if shipment.save
      context.shipment = shipment
    else
      context.fail!(message: shipment.errors.full_messages)
    end
  end

  private

  def params
    {
      reference: SecureRandom.uuid,
      hubee_folder_id: context.folder.id,
    }
  end
end
