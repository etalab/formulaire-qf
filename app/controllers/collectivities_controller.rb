class CollectivitiesController < ApplicationController
  before_action :set_collectivity, only: %i[select]

  def index
    @collectivities = Collectivity.active
  end

  def show
  end

  def select
    redirect_to collectivity_path(@collectivity_id)
  end

  private

  def set_collectivity
    @collectivity_id = params[:id]
  end
end
