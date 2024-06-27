class ShipmentsController < ApplicationController
  before_action :set_collectivity

  def show
    @shipment = Shipment.find_by(reference: params[:reference])
    @redirect_uri = Current.redirect_uri
  end

  def new
    @pivot_identity_facade = PivotIdentityFacade.new(Current.pivot_identity)
    @quotient_familial_facade = QuotientFamilialFacade.new(Current.quotient_familial)
  end

  def create
    hubee_recipient = HubEE::Recipient.new(siren: @collectivity.siret, branch_code: "04107")
    result = StoreQuotientFamilial.call(
      external_id: Current.external_id,
      pivot_identity: Current.pivot_identity,
      quotient_familial: Current.quotient_familial,
      recipient: hubee_recipient,
      user: Current.user
    )

    if result.success?
      redirect_to collectivity_shipment_path(@collectivity.siret, result.shipment.reference)
    else
      raise
    end
  end

  private

  def set_collectivity
    @collectivity = Current.collectivity
  end
end
