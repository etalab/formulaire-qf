class DatapassWebhook::CreateHubEESubscription < BaseInteractor
  delegate :collectivity_email, :datapass_id, :hubee_organization_payload, :applicant, to: :context

  def call
    context.hubee_subscription_payload = create_subscription_on_hubee
  end

  private

  def applicant_payload
    {
      email: applicant["email"],
      firstName: applicant["given_name"],
      lastName: applicant["family_name"],
      function: applicant["job_title"],
      phoneNumber: applicant["phone_number"].gsub(/[\s.-]/, ""),
    }
  end

  def create_subscription_on_hubee
    hubee_api_client.create_subscription(datapass_id:, collectivity_email:, organization_payload: hubee_organization_payload, process_code:, applicant_payload:)
  end

  def hubee_api_client
    @hubee_api_client ||= HubEE::AdminApi.new
  end

  def process_code
    "FormulaireQF"
  end
end
