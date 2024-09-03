class AlternativesController < ApplicationController
  before_action :set_collectivity

  def index
    # TODO remove that
    # flash[:info] = {
    #   title: t("shipments.qf_v2_error.title"),
    #   text: t("shipments.qf_v2_error.text", message: "sorry not sorry"),
    # }
  end

  def create
    # flash[:error] = {
    #   title: t("shipments.qf_v1_error.title"),
    #   text: t("shipments.qf_v1_error.text", message: result.message),
    # }
    # redirect_to collectivity_shipment_error_path(Current.collectivity.siret)
  end

  private

  def set_collectivity
    @collectivity = Current.collectivity
  end

  def alternative_params
    params.require(:alternative).permit(:allocataire_number, :postal_code)
  end
end
