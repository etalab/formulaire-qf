class Api::CollectivitiesController < Api::ApplicationController
  before_action :authenticate, only: :create

  def index
    render json: Collectivity.active.order(:name), each_serializer: Api::CollectivitiesSerializer
  end

  def create
    p "coucou"
    render json: {}, status: :created
  end
end
