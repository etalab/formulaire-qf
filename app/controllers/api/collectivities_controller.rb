class Api::CollectivitiesController < Api::ApplicationController
  def index
    render json: Collectivity.active.order(:name), each_serializer: Api::CollectivitiesSerializer
  end
end
