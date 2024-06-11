class ShipmentsController < ApplicationController
  before_action :set_collectivity

  def show
  end

  def new
  end

  def create
    hubee_recipient = HubEE::Recipient.new(siren: @collectivity.siren, branch_code: "04107")
    result = StoreQuotientFamilial.call(user: Current.user, identity: Current.pivot_identity, quotient_familial: Current.quotient_familial, recipient: hubee_recipient)

    if result.success?
      redirect_to collectivity_shipment_path(params[:collectivity_id], result.shipment)
    else
      raise
    end
  end

  private

  def set_collectivity
    # TODO : get the collectivity from the db, by siren
    @collectivity = OpenStruct.new(id: params[:collectivity_id], siren: "21040107100019")
  end
end
