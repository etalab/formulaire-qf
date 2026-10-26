class SetupCollectivityJob < ApplicationJob
  def perform(datapass_id:, collectivity_siret:, collectivity_email:, service_provider:, applicant:)
    if applicant["phone_number"].blank?
      Sentry.capture_message(
        "DataPass webhook: applicant phone number missing, collectivity not set up",
        extra: {siret: collectivity_siret, datapass_id:}
      )
    end

    organization = Organization.new(collectivity_siret)
    DatapassWebhook::SetupCollectivity.call(datapass_id:, organization:, collectivity_email:, service_provider:, applicant:)
  end
end
