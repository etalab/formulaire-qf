class CreateShipment < BaseInteractor
  def call
    shipment = context.shipment
    shipment.hubee_folder_id = context.folder.id

    if !shipment.save
      context.fail!(message: shipment.errors.full_messages)
    end
  end
end
