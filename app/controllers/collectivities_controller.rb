class CollectivitiesController < ApplicationController
  def index
    @collectivities = Collectivity.active
  end
end
