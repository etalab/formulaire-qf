require "rails_helper"

RSpec.describe Hubee::Api, type: :api do
  describe ".session" do
    subject(:session) { described_class.session }

    it { is_expected.to be_a(described_class) }
  end

  describe "API" do
    let(:access_token) { "access_token_123" }
    let(:session) { described_class.session }

    before do
      stub_request(:post, "https://auth.bas.hubee.numerique.gouv.fr/oauth2/token")
        .with(
          body: "{\"scope\":\"OSL\",\"grant_type\":\"client_credentials\"}",
          headers: {
            "Authorization" => "Basic bm90X2FfcmVhbF9pZDpub3RfYV9yZWFsX3NlY3JldA==",
            "Content-Type" => "application/json",
            "Host" => "auth.bas.hubee.numerique.gouv.fr",
          }
        )
        .to_return(status: 200, body: "{\"access_token\":\"#{access_token}\"}", headers: {})
    end

    describe "#create_folder" do
      subject(:create_folder) { session.create_folder(folder: folder) }

      let(:attachments) { [attachment] }
      let(:attachment) { build(:hubee_attachment, :with_file) }

      let(:folder) { build(:hubee_folder, attachments: attachments) }

      context "when the folder is succesfully created" do
        let(:response) {
          {
            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            globalStatus: "HUBEE_RECEIVED",
            processCode: "FormulaireQF",
            createDateTime: "2024-05-22T13:36:01.781Z",
            closeDateTime: "2024-05-22T13:36:01.781Z",
            applicant: {
              firstName: "David",
              lastName: "Heinemeier Hansson",
            },
            externalId: "external_id",
            updateDateTime: "2024-05-22T13:36:01.781Z",
            cases: [
              {
                id: "d7923df5-c071-400e-87b5-f0d01d539aa5",
                status: "HUBEE_NOTIFIED",
                recipient: {
                  type: "SI",
                  companyRegister: "123456789",
                  branchCode: "1234",
                },
                externalId: "case_id",
                updateDateTime: "2024-05-22T13:36:01.781Z",
                transmissionDateTime: "2024-05-22T13:36:01.781Z",
              },
            ],
            attachments: [
              {
                id: "a66abb0c-52d1-4e50-9195-22526fb7ce92",
                status: "PENDING",
                fileName: "FormulaireQF.json",
                type: "FormulaireQF",
                size: 22,
                mimeType: "application/json",
                recipients: [
                  "external_id-01",
                ],
              },
            ],
          }
        }

        before do
          stub_request(:post, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders")
            .with(
              body: "{\"processCode\":\"FormulaireQF\",\"externalId\":\"external_id\",\"applicant\":{\"firstName\":\"David\",\"lastName\":\"Heinemeier Hansson\"},\"cases\":[{\"recipient\":{\"companyRegister\":\"123456789\",\"branchCode\":\"1234\",\"type\":\"SI\"},\"externalId\":\"case_id\"}],\"attachments\":[{\"fileName\":\"FormulaireQF.json\",\"type\":\"FormulaireQF\",\"size\":22,\"mimeType\":\"application/json\",\"recipients\":[\"external_id-01\"]}]}",
              headers: {
                "Authorization" => "Bearer access_token_123",
                "Content-Type" => "application/json",
                "Host" => "api.bas.hubee.numerique.gouv.fr",
              }
            )
            .to_return(status: 200, body: response.to_json, headers: {})
        end

        it "fills in the ids from the response" do
          expect(create_folder).to have_attributes(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", attachments: [an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce92")])
        end
      end
    end

    describe "#delete_folder" do
      subject(:delete_folder) { session.delete_folder(folder_id: folder_id) }

      let(:folder_id) { "12345folder_id" }

      context "when the folder is succesfully deleted" do
        before do
          stub_request(:delete, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/12345folder_id")
            .with(
              headers: {
                "Authorization" => "Bearer access_token_123",
                "Content-Type" => "application/json",
                "Host" => "api.bas.hubee.numerique.gouv.fr",
              }
            )
            .to_return(status: 204, body: "", headers: {})
        end

        it "deletes the folder" do
          expect(delete_folder).to have_attributes({})
        end
      end
    end

    describe "#upload_attachment" do
      subject(:upload_attachment) { session.upload_attachment(attachment: attachment, folder_id: folder_id) }

      let(:attachment) { build(:hubee_attachment, :with_file, id: "12345attachment_id") }
      let(:folder_id) { "12345folder_id" }

      context "when the attachment is succesfully uploaded" do
        before do
          stub_request(:put, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/12345folder_id/attachments/12345attachment_id")
            .with(
              headers: {
                "Authorization" => "Bearer access_token_123",
                "Host" => "api.bas.hubee.numerique.gouv.fr",
              }
            )
            .to_return(status: 204, body: "", headers: {})
        end

        it "uploads the attachment" do
          expect(upload_attachment).to have_attributes({})
        end
      end
    end

    describe "#mark_folder_complete" do
      subject(:mark_folder_complete) { session.mark_folder_complete(folder_id: folder_id) }

      let(:folder_id) { "12345folder_id" }

      context "when the folder is succesfully marked as complete" do
        before do
          stub_request(:patch, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/12345folder_id")
            .with(
              body: "{\"globalStatus\":\"HUBEE_COMPLETED\"}",
              headers: {
                "Authorization" => "Bearer access_token_123",
                "Host" => "api.bas.hubee.numerique.gouv.fr",
              }
            )
            .to_return(status: 204, body: "", headers: {})
        end

        it "marks the folder as complete" do
          expect(mark_folder_complete).to have_attributes({})
        end
      end
    end
  end
end
