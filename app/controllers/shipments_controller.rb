class ShipmentsController < ApplicationController
  before_action :require_quotient_familial, only: %i[new create]
  before_action :set_collectivity

  rescue_from ActionController::InvalidAuthenticityToken, with: :ask_for_france_connect

  def show
    @shipment = Current.collectivity.shipments.find_by!(reference: params.expect(:reference))
    @redirect_uri = Current.redirect_uri
  end

  def new
    no_store
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
      session_key: Current.shipment_key,
      user: Current.user
    )

    reset_session_for_next_person

    if result.success?
      redirect_to collectivity_shipment_path(@collectivity.siret, result.shipment.reference)
    else
      flash[:error] = {
        title: t(".hubee_error.title"),
        text: t(".hubee_error.text", collectivity: @collectivity.display_name),
      }
      redirect_to collectivity_shipment_error_path(@collectivity.siret)
    end
  end

  private

  def ask_for_france_connect
    redirect_to collectivity_path(params[:collectivity_id])
  end

  def require_quotient_familial
    redirect_to collectivity_path(params[:collectivity_id]) if Current.quotient_familial.blank?
  end

  def set_collectivity
    @collectivity = CollectivityDecorator.new(Current.collectivity)
  end
end
