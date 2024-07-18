class HubEE::Api::Response
  attr_reader :net_response

  delegate :body, to: :net_response, prefix: true, private: true

  def initialize(net_response)
    @net_response = net_response
  end

  def body
    JSON.parse(page || "{}")
  rescue JSON::ParserError
    page
  end

  def code
    net_response.code.to_i
  end

  def success?
    net_response.is_a?(Net::HTTPSuccess)
  end

  private

  def page
    if zipped?
      Zlib::GzipReader.new(StringIO.new(net_response_body)).read
    else
      net_response_body
    end
  end

  def zipped?
    net_response.header["Content-Encoding"] == "gzip"
  end
end
