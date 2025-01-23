require "faraday"

class HubEE::Base
  protected

  def http_connection(&block)
    Faraday.new do |conn|
      conn.request :retry, max: 5
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 2
      yield(conn) if block
    end
  end

  def consumer_key
    Rails.application.credentials.hubee.admin.client_id
  end

  def consumer_secret
    Rails.application.credentials.hubee.admin.client_secret
  end
end
