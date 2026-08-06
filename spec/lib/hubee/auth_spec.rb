RSpec.describe HubEE::Auth do
  describe "#access_token" do
    subject(:access_token) { described_class.new.access_token }

    before do
      stub_request(:post, Settings.hubee.token_url)
        .with(body: "grant_type=client_credentials&scope=DATAPASS")
        .to_return(
          status: 200,
          body: {"access_token" => "hubee_access_token"}.to_json,
          headers: {"Content-Type" => "application/json"}
        )
    end

    it "requests a token with the datapass scope" do
      expect(access_token).to eq("hubee_access_token")
    end
  end
end
