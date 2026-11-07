class StoreQuotientFamilial < BaseOrganizer
  organize InsertShipment, UploadQuotientFamilialToHubEE, CreateShipment

  around do |interactor|
    ActiveRecord::Base.transaction { interactor.call }
  rescue ActiveRecord::RecordNotUnique
    raise if context.session_key.blank?

    context.shipment = Shipment.find_by!(session_key: context.session_key)
  end
end
