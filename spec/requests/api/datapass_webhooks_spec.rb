require "rails_helper"

RSpec.describe "DataPass webhook", type: :request do
  def post_signed(body, query: "", content_type: "application/json")
    signature = HubSignature.new(nil, body).compute_signature
    post "/api/datapass/webhook#{query}", params: body, headers: {"Content-Type" => content_type, "X-Hub-Signature-256" => signature}
  end

  def notification(event:)
    {
      event:,
      model_type: "Authorization",
      model_id: 42,
      data: {
        organization: {siret: "11111111111111"},
        applicant: {email: "body@example.org"},
        service_provider: {id: "body-provider"},
      },
    }.to_json
  end

  let(:body_data) do
    {
      datapass_id: 42,
      collectivity_siret: "11111111111111",
      collectivity_email: "body@example.org",
      service_provider: {"id" => "body-provider"},
      applicant: {"email" => "body@example.org"},
    }
  end

  it "enqueues the setup with the signed body's data" do
    expect { post_signed(notification(event: "approve")) }.to have_enqueued_job(SetupCollectivityJob).with(**body_data)
  end

  it "ignores data sent outside the signed body" do
    query = "?model_id=7&data[organization][siret]=22222222222222&data[applicant][email]=query@example.org"

    expect { post_signed(notification(event: "approve"), query:) }.to have_enqueued_job(SetupCollectivityJob).with(**body_data)
  end

  it "ignores an event sent outside the signed body" do
    expect { post_signed(notification(event: "submit"), query: "?event=approve") }.not_to have_enqueued_job(SetupCollectivityJob)
  end

  it "answers bad request to a signed body that is not JSON" do
    post_signed("not json", content_type: "text/plain")

    expect(response).to have_http_status(:bad_request)
  end

  it "rejects a body whose signature does not match" do
    post "/api/datapass/webhook", params: notification(event: "approve"), headers: {"Content-Type" => "application/json", "X-Hub-Signature-256" => "sha256=0"}

    expect(response).to have_http_status(:unauthorized)
  end
end
