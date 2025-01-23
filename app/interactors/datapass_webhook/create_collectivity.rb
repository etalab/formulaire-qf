class DatapassWebhook::CreateCollectivity < BaseInteractor
  delegate :organization, to: :context

  def call
    context.collectivity = find_or_create_collectivity
  end

  private

  def editor_id
    Hash(context.service_provider).fetch("id", nil)
  end

  def find_or_create_collectivity
    collectivity = Collectivity.find_or_initialize_by(siret: organization.siret)

    collectivity.update!(
      name: organization.denomination,
      code_cog: organization.code_commune_etablissement,
      departement: organization.code_postal_etablissement[0..1],
      status: :active,
      editor: editor_id
    )
  end
end
