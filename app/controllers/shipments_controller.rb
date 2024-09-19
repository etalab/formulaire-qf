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

  def error
  end

  def create
    result = StoreQuotientFamilial.call(
      collectivity: Current.collectivity,
      external_id: Current.external_id,
      pivot_identity: Current.pivot_identity,
      original_pivot_identity: Current.original_pivot_identity,
      quotient_familial: Current.quotient_familial,
      user: Current.user
    )

    if result.success?
      redirect_to collectivity_shipment_path(@collectivity.siret, result.shipment.reference)
    else
      flash[:error] = {
        title: t(".hubee_error.title"),
        text: t(".hubee_error.text", collectivity: @collectivity.display_name),
      }

      redirect_to collectivity_shipment_error_path(Current.collectivity.siret)
    end
  end

  private

  def set_collectivity
    @collectivity = CollectivityDecorator.new(Current.collectivity)
  end
end
