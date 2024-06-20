class ShipmentsController < ApplicationController
  before_action :set_collectivity

  def show
  end

  def new
  end

  def create
    hubee_recipient = HubEE::Recipient.new(siren: @collectivity.siret, branch_code: "04107")
    result = StoreQuotientFamilial.call(user: Current.user, pivot_identity: Current.pivot_identity, quotient_familial: Current.quotient_familial, recipient: hubee_recipient)

    if result.success?
      redirect_to collectivity_shipment_path(@collectivity.siret, result.shipment)
    else
      raise
    end
  end

  private

  def set_collectivity
    @collectivity = Current.collectivity
  end
end
