class SetupCollectivityJob < ApplicationJob
  class MissingApplicantPhoneNumber < StandardError; end

  def perform(datapass_id:, collectivity_siret:, collectivity_email:, service_provider:, applicant:)
    if applicant["phone_number"].to_s.gsub(/[\s.-]/, "").empty?
      Sentry.configure_scope { |scope| scope.set_fingerprint([MissingApplicantPhoneNumber.name, datapass_id.to_s]) }
      raise MissingApplicantPhoneNumber, "DataPass #{datapass_id}, SIRET #{collectivity_siret}: applicant phone number missing, rerun this job with the phone once the team has it"
    end

    organization = Organization.new(collectivity_siret)
    DatapassWebhook::SetupCollectivity.call(datapass_id:, organization:, collectivity_email:, service_provider:, applicant:)
  end
end
