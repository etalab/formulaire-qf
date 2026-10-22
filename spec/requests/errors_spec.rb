RSpec.describe "Authentication errors", type: :request do
  describe "GET /auth/failure" do
    it "sends Sentry only the error message" do
      expect(Sentry).to receive(:capture_message).with(
        "Authentication failure invalid_credentials",
        extra: {message: "invalid_credentials"}
      )

      get "/auth/failure", params: {message: "invalid_credentials", strategy: "france_connect", nom: "DUBOIS"}
    end
  end
end
