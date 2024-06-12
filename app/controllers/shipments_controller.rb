class ShipmentsController < ApplicationController
  before_action :set_collectivity

  def show
  end

  def new
  end

  def create
    hubee_recipient = HubEE::Recipient.new(siren: @collectivity.siret, branch_code: "04107")
    result = StoreQuotientFamilial.call(user: Current.user, identity: Current.pivot_identity, quotient_familial: Current.quotient_familial, recipient: hubee_recipient)

    if result.success?
      redirect_to collectivity_shipment_path(@collectivity, result.shipment)
    else
      raise
    end
  end

  private

  def set_collectivity
    @collectivity = Collectivity.find_by(siret: params[:collectivity_id])
  end
end
