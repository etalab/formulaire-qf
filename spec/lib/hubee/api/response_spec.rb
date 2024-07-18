require "rails_helper"

describe HubEE::Api::Response do
  subject(:response) { described_class.new(net_response) }

  let(:header) { {} }
  let(:net_body) { '{"key": "value"}' }
  let(:code) { "200" }
  let(:net_response) { double("Net::HTTPSuccess", body: net_body, header:, code: code) }

  describe "#body" do
    subject(:body) { response.body }

    context "when the response is zipped" do
      let(:file) { StringIO.new }
      let(:gzip) { Zlib::GzipWriter.new(file) }
      let(:header) { {"Content-Encoding" => "gzip"} }
      let(:net_body) { file.string }

      before do
        gzip.write('{"key": "value"}')
        gzip.close
      end

      it { is_expected.to eq("key" => "value") }
    end

    context "when the response is not zipped" do
      it { is_expected.to eq("key" => "value") }
    end

    context "when the body is not a valid json" do
      let(:net_body) { "page not found (JSON::ParserError)\n" }

      it { is_expected.to eq(net_body) }
    end
  end

  describe "#code" do
    subject { response.code }

    it { is_expected.to eq 200 }
  end

  describe "#success?" do
    subject(:success_tr) { response.success? }

    context "when the response is successful" do
      let(:net_response) { Net::HTTPSuccess.new("1.1", "200", "OK") }

      it { is_expected.to be(true) }
    end

    context "when the response is not successful" do
      let(:net_response) { double("Net::HTTPServerError", body: net_body, header:, code: "500") }

      it { is_expected.to be(false) }
    end
  end
end
