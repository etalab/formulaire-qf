class PopulateHubEESandboxJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return if Rails.env.production?

    subscriptions = HubEE::Api.session.active_subscriptions.body
    subscriptions.each do |subscription|
      siret = subscription.dig("subscriber", "companyRegister")
      code_cog = subscription.dig("subscriber", "branchCode")
      name = subscription.dig("subscriber", "name")
      Rails.logger.debug { "### Adding data to #{name} ###" }

      collectivity = Collectivity.find_or_initialize_by(siret:, code_cog:, name:, status: :active)
      result = UploadQuotientFamilialToHubEE.call(collectivity: collectivity, pivot_identity: pivot_identity, quotient_familial: quotient_familial)

      if result.success?
        Rails.logger.debug { "   >>> Data added to #{name}, id: #{result.folder.id} ###" }
      else
        Rails.logger.debug { "   !!! Data not added to #{name}" }
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
