class CollectivitiesController < ApplicationController
  before_action :set_collectivity, only: %i[select show no_france_connect]
  before_action :move_params_to_session, only: :show

  def index
    @collectivities = Collectivity.active
  end

  def show
    @qr_code_url = simple_collectivity_url(@collectivity.siret)
    qrcode = RQRCode::QRCode.new(@qr_code_url)

    @qr_code = Base64.strict_encode64(qrcode.as_png(
      border_modules: 0,
      fill: :white,
      size: 480
    ).to_s)
  end

  def no_france_connect
  end

  def select
    if shipment_data_is_present?
      redirect_to collectivity_new_shipment_path(@collectivity.siret)
    else
      redirect_to collectivity_path(@collectivity.siret)
    end
  end

  private

  def move_params_to_session
    session[:external_id] ||= params[:external_id]
    session[:redirect_uri] ||= params[:redirect_uri]
    session[:siret] ||= @collectivity.siret
    SetupCurrentData.call(session: session, params: params)
  end

  def set_collectivity
    @collectivity = Collectivity.find_by!(siret: params[:id])
  end

  def shipment_data_is_present?
    # TODO : I doubt it's the perfect way to check that
    # we should use the shipment validations once they'll exist
    Current.quotient_familial.present? && Current.pivot_identity.present?
  end
end
