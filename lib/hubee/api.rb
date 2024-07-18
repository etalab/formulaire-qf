require "uri"
require "net/http"
require "json"

class HubEE::Api
  def self.session
    new
  end

  def active_subscriptions
    url = "#{Settings.hubee.base_url}/referential/v1/subscriptions"
    get(url, query_params: {maxResult: 5000, status: "Actif", processCode: "FormulaireQF"})
  end

  def create_folder(folder:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/folders"

    post(url, body: FolderMapper.normalize(folder.to_h))
  end

  def delete_folder(folder_id:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}"

    delete(url)
  end

  def delete_notification(notification_id:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/notifications/#{notification_id}"

    delete(url)
  end

  def event(id:, case_id:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/cases/#{case_id}/events/#{id}"

    get(url)
  end

  def mark_folder_complete(folder_id:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}"

    patch(url, body: {"globalStatus" => "HUBEE_COMPLETED"})
  end

  def notifications(items_count: 50)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/notifications"

    get(url, query_params: {maxResult: items_count})
  end

  def update_event(id:, case_id:, status: "RECEIVED")
    url = "#{Settings.hubee.base_url}/teledossiers/v1/cases/#{case_id}/events/#{id}"

    patch(url, body: {"status" => status})
  end

  def upload_attachment(attachment:, folder_id:)
    url = "#{Settings.hubee.base_url}/teledossiers/v1/folders/#{folder_id}/attachments/#{attachment.id}"

    put(url, body: nil) do |request, body|
      request["Content-Type"] = "application/octet-stream"
      request["Authorization"] = "Bearer #{access_token}"
      request.body_stream = attachment.file
      request.content_length = attachment.file_size
    end
  end

  private

  def access_token
    @access_token ||= request_auth_token
  end

  def request_auth_token
    url = Settings.hubee.token_url
    client_id = Settings.hubee.client_id
    client_secret = Settings.hubee.client_secret
    authorization_token = Base64.strict_encode64("#{client_id}:#{client_secret}")

    body = {scope: "OSL", grant_type: "client_credentials"}

    response = post(url, body:) do |request|
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Basic #{authorization_token}"
      request.body = body.to_json
    end

    response.body.dig("access_token")
  end

  def delete(url, &)
    uri = URI(url)

    request(net_class: Net::HTTP::Delete, uri: uri, &)
  end

  def get(url, query_params: {}, &)
    uri = URI(url)
    uri.query = URI.encode_www_form(query_params)

    request(net_class: Net::HTTP::Get, uri: uri, &)
  end

  def patch(url, body:, &)
    uri = URI(url)

    request(net_class: Net::HTTP::Patch, uri: uri, body: body, &)
  end

  def post(url, body:, &)
    uri = URI(url)

    request(net_class: Net::HTTP::Post, uri: uri, body: body, &)
  end

  def put(url, body:, &)
    uri = URI(url)

    request(net_class: Net::HTTP::Put, uri: uri, body: body, &)
  end

  def request(net_class:, uri:, body: nil)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = net_class.new(uri)

    if block_given?
      yield(request)
    else
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{access_token}"
      request.body = body.to_json if body
    end

    response = https.request(request)
    handle_error(request, response)

    Response.new(response)
  end

  def handle_error(request, response)
    return if response.is_a?(Net::HTTPSuccess)

    path = request.uri.path
    method = request.method
    code = response.code.to_i

    extra = {
      user_sub: Current.user.try(:sub),
      siret: @siret,
      request_id: response["X-Request-Id"],
      request_body: request.body,
      response_body: response.body,
    }

    Sentry.capture_message("Hubee Error #{code} on #{method} #{path}", extra: extra)
  end
end
