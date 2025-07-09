class Api::DatapassWebhooksController < ActionController::API
  before_action :verify_hub_signature!, only: :create

  def create
    if event == "approve"
      SetupCollectivityJob.perform_later(datapass_id:, collectivity_siret:, collectivity_email:, service_provider:, applicant:)
    end
  end

  private

  def applicant
    webhook_params.dig("data", "applicant")
  end

  def collectivity_email
    webhook_params.dig("data", "applicant", "email")
  end

  def collectivity_siret
    webhook_params.dig("data", "organization", "siret")
  end

  def datapass_id
    webhook_params["model_id"]
  end

  def event
    webhook_params["event"]
  end

  def hub_signature
    request.headers["X-Hub-Signature-256"]
  end

  def hub_signature_valid?
    HubSignature.new(hub_signature, request.raw_post).valid?
  end

  def service_provider
    webhook_params.dig("data", "service_provider")
  end

  def unauthorized
    render json: {error: "Unauthorized"}, status: :unauthorized
  end

  def webhook_params
    @webhook_params ||= params.permit(
      :event,
      :model_type,
      :model_id,
      :fired_at,
      data: {}
    ).to_h
  end

  def verify_hub_signature!
    unauthorized unless hub_signature_valid?
  end
end
