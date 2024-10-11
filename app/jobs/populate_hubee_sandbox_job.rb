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
      result = UploadQuotientFamilialToHubEE.call(
        collectivity:,
        pivot_identity:,
        original_pivot_identity:,
        quotient_familial:
      )

      if result.success?
        Rails.logger.debug { "   >>> Data added to #{name}, id: #{result.folder.id} ###" }
      else
        Rails.logger.debug { "   !!! Data not added to #{name}" }
      end
    end
  end

  private

  def pivot_identity
    PivotIdentity.new(**FranceConnect::IdentityMapper.normalize(original_pivot_identity))
  end

  def original_pivot_identity
    {
      family_name: "Heinemeier Hansson",
      given_name: "David",
      gender: "male",
      birthdate: "1979-10-15",
      birthplace: nil,
      birthcountry: "99135",
    }
  end

  def quotient_familial
    FactoryBot.build(:quotient_familial_v2_payload)
  end
end
