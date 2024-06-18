class CollectivitiesController < ApplicationController
  before_action :set_collectivity, only: %i[select show]

  def index
    @collectivities = Collectivity.active
  end

  def show
    session["siret"] = @collectivity.siret
  end

  def select
    if shipment_data_is_present?
      redirect_to new_collectivity_shipment_path(@collectivity.siret)
    else
      redirect_to collectivity_path(@collectivity.siret)
    end
  end

  private

  def set_collectivity
    @collectivity = Collectivity.find_by!(siret: params[:id])
  end

  def shipment_data_is_present?
    # TODO : I doubt it's the perfect way to check that
    # we should use the shipment validations once they'll exist
    Current.quotient_familial.present? && Current.pivot_identity.present?
  end
end
