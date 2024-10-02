class Api::CollectivitiesController < Api::ApplicationController
  before_action :authenticate, only: :create

  def index
    render json: Collectivity.active.order(:name), each_serializer: Api::CollectivitiesSerializer
  end

  def create
    collectivity = Collectivity.build(collectivity_params)

    if collectivity.save
      render json: {collectivity: collectivity}, status: :created
    else
      status = collectivity.errors.of_kind?(:siret, :taken) ? :conflict : :unprocessable_entity
      render json: {errors: collectivity.errors}, status: status
    end
  end

  private

  def collectivity_params
    params.require(:collectivity).permit(:name, :siret, :code_cog, :status, :editor, :departement)
  end
end
