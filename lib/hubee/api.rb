require "uri"
require "net/http"
require "json"

class HubEE::Api
  def self.session
    new
  end

  def active_subscriptions
    base_url = URI("#{Settings.hubee.base_url}/referential/v1/subscriptions")
    base_url.query = URI.encode_www_form(maxResult: 5000, status: "Actif", processCode: "FormulaireQF")

    Rails.logger.debug base_url
    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    res = https.request(request)
    if res.header["Content-Encoding"].eql?("gzip")
      sio = StringIO.new(res.body)
      gz = Zlib::GzipReader.new(sio)
      page = gz.read
    else
      page = res.body
    end

    subscriptions = JSON.parse(page || "{}")

    Rails.logger.debug page
    Rails.logger.debug subscriptions

    subscriptions
  end

  def create_folder(folder:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/folders")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    request.body = FolderMapper.normalize(folder.to_h).to_json
    folder_response = https.request(request)
    response_hash = JSON.parse(folder_response.body || "{}")

    attachments = folder.attachments.map do |attachment|
      from_response = response_hash["attachments"].find { |hash| hash["fileName"] == attachment.file_name }
      attachment.with(id: from_response["id"])
    end

    cases = folder.cases.map do |kase|
      from_response = response_hash["cases"].find { |hash| hash["externalId"] == kase.external_id }
      kase.with(id: from_response["id"])
    end
    enhanced_folder = folder.with(id: response_hash["id"], attachments: attachments, cases: cases)

    Rails.logger.debug request.body
    Rails.logger.debug "###"
    Rails.logger.debug folder_response.body
    Rails.logger.debug "###"
    Rails.logger.debug enhanced_folder

    enhanced_folder
  end

  def delete_folder(folder_id:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    response = https.request(request)
    delete_response = JSON.parse(response.body || "{}")

    Rails.logger.debug response
    Rails.logger.debug delete_response

    delete_response
  end

  def delete_notification(notification_id:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/notifications/#{notification_id}")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Delete.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    response = https.request(request)
    body = JSON.parse(response.body || "{}")

    Rails.logger.debug { "DELETE notification #{notification_id}" }

    body
  end

  def event(id:, case_id:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/cases/#{case_id}/events/#{id}")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    response = https.request(request)
    event = JSON.parse(response.body || "{}")

    Rails.logger.debug response.body
    Rails.logger.debug event

    event
  end

  def notifications(items: 50)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/notifications")
    base_url.query = URI.encode_www_form(maxResult: items)

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    response = https.request(request)
    notifications = JSON.parse(response.body || "{}")

    Rails.logger.debug response.body
    Rails.logger.debug notifications

    notifications
  end

  def upload_attachment(attachment:, folder_id:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}/attachments/#{attachment.id}")
    Rails.logger.debug base_url

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Put.new(base_url)
    request["Content-Type"] = "application/octet-stream"
    request["Authorization"] = "Bearer #{access_token}"

    request.body_stream = attachment.file
    request.content_length = attachment.file_size

    attach_response = https.request(request)
    attachment = JSON.parse(attach_response.body || "{}")

    Rails.logger.debug attach_response.body
    Rails.logger.debug attachment

    attachment
  end

  def mark_folder_complete(folder_id:)
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Patch.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    params = {
      globalStatus: "HUBEE_COMPLETED",
    }
    request.body = params.to_json
    response = https.request(request)
    attachment = JSON.parse(response.body || "{}")

    Rails.logger.debug response.body
    Rails.logger.debug attachment

    attachment
  end

  def update_event(id:, case_id:, status: "RECEIVED")
    base_url = URI("#{Settings.hubee.base_url}/teledossiers/v1/cases/#{case_id}/events/#{id}")

    https = Net::HTTP.new(base_url.host, base_url.port)
    https.use_ssl = true

    request = Net::HTTP::Patch.new(base_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{access_token}"

    params = {
      status: status,
    }
    request.body = params.to_json
    response = https.request(request)
    event = JSON.parse(response.body || "{}")

    Rails.logger.debug response.body
    Rails.logger.debug event

    event
  end

  private

  def access_token
    @access_token ||= request_auth_token
  end

  def request_auth_token
    token_url = URI(Settings.hubee.token_url)
    client_id = Settings.hubee.client_id
    client_secret = Settings.hubee.client_secret
    authorization_token = Base64.strict_encode64("#{client_id}:#{client_secret}")

    https = Net::HTTP.new(token_url.host, token_url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(token_url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Basic #{authorization_token}"
    params = {
      scope: "OSL",
      grant_type: "client_credentials",
    }
    request.body = params.to_json

    token_response = https.request(request)
    JSON.parse(token_response.body).dig("access_token")
  end
end
