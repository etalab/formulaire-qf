class InsertShipment < BaseInteractor
  def call
    context.shipment = Shipment.create!(collectivity: context.collectivity, session_key: context.session_key)
  end
end
