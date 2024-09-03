class CnafV1FamilyQuotientsController < ApplicationController
  before_action :set_collectivity

  def index
  end

  def create
    result = GetAlternativeFamilyQuotient.call(siret: Current.collectivity.siret, **cnaf_v1_params)

    if result.success?
      session["quotient_familial"] = result.quotient_familial
      SetupCurrentData.call(session:, params:)

      redirect_to collectivity_new_shipment_path(Current.collectivity.siret)
    else
      flash[:error] = {
        title: t("shipments.qf_v1_error.title"),
        text: t("shipments.qf_v1_error.text", message: result.message),
      }

      redirect_to collectivity_shipment_error_path(Current.collectivity.siret)
    end
  end

  private

  def set_collectivity
    @collectivity = Current.collectivity
  end

  def cnaf_v1_params
    params.require(:alternative).permit(:allocataire_number, :postal_code)
  end
end
