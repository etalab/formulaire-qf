class CollectivitiesController < ApplicationController
  before_action :set_collectivity, only: %i[select show]

  def index
    @collectivities = Collectivity.active
  end

  def show
    session["collectivity_id"] = @collectivity.siret
  end

  def select
    redirect_to collectivity_path(@collectivity.siret)
  end

  private

  def set_collectivity
    @collectivity = Collectivity.find_by(siret: params[:id])
  end
end
