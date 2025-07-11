# :nocov:
class HubEE::AdminApi < HubEE::Base
  class NotFound < StandardError; end

  class AlreadyExists < StandardError; end

  def find_or_create_organization(organization, email_demandeur = nil)
    find_organization(organization)
  rescue NotFound
    create_organization(organization, email_demandeur)
  end

  def find_organization(organization)
    http_connection.get("#{host}/referential/v1/organizations/SI-#{organization.siret}-#{organization.code_commune_etablissement}").body
  rescue Faraday::ResourceNotFound
    raise NotFound
  end

  def create_organization(organization, email)
    http_connection.post(
      "#{host}/referential/v1/organizations",
      {
        type: "SI",
        companyRegister: organization.siret,
        branchCode: organization.code_commune_etablissement,
        email:,
        name: organization.denomination,
        country: "France",
        postalCode: organization.code_postal_etablissement,
        territory: organization.code_commune_etablissement,
        status: "Actif",
      }.to_json,
      "Content-Type" => "application/json"
    ).body
  rescue Faraday::BadRequestError => e
    raise AlreadyExists if already_exists_error?(e)

    raise
  end

  def create_subscription(datapass_id:, collectivity_email:, organization_payload:, process_code:, editor_payload: {}, applicant_payload: {})
    subscription_payload = find_or_create_inactive_subscription(datapass_id:, collectivity_email:, organization_payload:, process_code:, applicant_payload:)
    activate_subscription(subscription_payload, editor_payload)
    subscription_payload
  end

  def find_subscription(organization_payload, process_code)
    request = http_connection { |conn| conn.request :gzip }.get(
      "#{host}/referential/v1/subscriptions",
      companyRegister: organization_payload["companyRegister"],
      processCode: process_code
    )
    request.body.first
  end

  protected

  def host
    Settings.hubee.base_url
  end

  def already_exists_error?(faraday_error)
    faraday_error.response[:body]["errors"].any? do |error|
      error["message"].include?("already exists")
    end
  end

  def http_connection(&block)
    super do |conn|
      conn.request :authorization, "Bearer", -> { HubEE::Auth.new.access_token }
      yield(conn) if block
    end
  end

  private

  def activate_subscription(subscription_payload, editor_payload = {}) # rubocop:disable Metrics/AbcSize
    subscription_id = subscription_payload["id"]
    return if subscription_id.blank?

    payload = subscription_payload.with_indifferent_access.merge({
      status: "Actif",
      activateDateTime: DateTime.now.iso8601,
      accessMode: "PORTAIL",
      notificationFrequency: "Unitaire",
    }.with_indifferent_access)

    payload.delete("id")
    payload.delete("creationDateTime")
    payload.merge!(editor_payload.with_indifferent_access)

    http_connection.put(
      "#{host}/referential/v1/subscriptions/#{subscription_id}",
      payload.to_json,
      "Content-Type" => "application/json"
    ).body
  end

  def create_inactive_subscription(datapass_id:, collectivity_email:, organization_payload:, process_code:, applicant_payload:) # rubocop:disable Metrics/AbcSize
    http_connection.post(
      "#{host}/referential/v1/subscriptions",
      {
        datapassId: datapass_id.to_i,
        notificationFrequency: "Unitaire",
        processCode: process_code,
        subscriber: {
          type: "SI",
          companyRegister: organization_payload["companyRegister"],
          branchCode: organization_payload["branchCode"],
        },
        email: collectivity_email,
        status: "Inactif",
        localAdministrator: applicant_payload,
        validateDateTime: DateTime.now.iso8601,
        updateDateTime: DateTime.now.iso8601,
      }.to_json,
      "Content-Type" => "application/json"
    ).body
  rescue Faraday::BadRequestError => e
    raise AlreadyExists if already_exists_error?(e)

    raise
  end

  def find_or_create_inactive_subscription(datapass_id:, collectivity_email:, organization_payload:, process_code:, applicant_payload: {})
    create_inactive_subscription(datapass_id:, collectivity_email:, organization_payload:, process_code:, applicant_payload:)
  rescue AlreadyExists
    find_subscription(organization_payload, process_code)
  end
end
