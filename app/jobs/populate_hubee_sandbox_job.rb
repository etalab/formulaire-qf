class PopulateHubEESandboxJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return if Rails.env.production?

    subscriptions = HubEE::Api.session.active_subscriptions
    subscriptions.each do |subscription|
      Rails.logger.debug { "### Adding data to #{subscription.dig("subscriber", "name")} ###" }
      recipient = HubEE::Recipient.new(siren: subscription.dig("subscriber", "companyRegister"), branch_code: subscription.dig("subscriber", "branchCode"))
      result = UploadQuotientFamilialToHubEE.call(recipient: recipient, pivot_identity: pivot_identity, quotient_familial: quotient_familial)
      if result.success?
        Rails.logger.debug { "   >>> Data added to #{subscription.dig("subscriber", "name")}, id: #{result.folder.id} ###" }
      else
        Rails.logger.debug { "   !!! Data not added to #{subscription.dig("subscriber", "name")}" }
      end
    end
  end

  private

  def pivot_identity
    PivotIdentity.new(first_names: ["David"], last_name: "Heinemeier Hansson", birth_country: "99135", birthplace: nil, birthdate: Date.new(1979, 10, 15), gender: :male)
  end

  def quotient_familial
    FactoryBot.attributes_for(:quotient_familial_payload)
  end
end
