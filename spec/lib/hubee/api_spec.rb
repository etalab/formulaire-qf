RSpec.describe HubEE::Api, type: :api do
  describe ".session" do
    subject(:session) { described_class.session }

    it { is_expected.to be_a(described_class) }
  end

  describe "API" do
    let(:access_token) { "access_token_123" }
    let(:session) { described_class.session }

    before do
      stub_hubee_token
      allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")
    end

    describe "#active_subscriptions" do
      subject(:response) { session.active_subscriptions }

      before do
        stub_hubee_active_subscriptions
      end

      let(:expected_body) do
        array_including(
          a_hash_including(
            "subscriber" => a_hash_including(
              "name" => "COMMUNE DE MAJASTRES",
              "companyRegister" => "21040107100019",
              "branchCode" => "04107"
            )
          )
        )
      end

      it { is_expected.to be_a_success }

      it "returns the active subscriptions" do
        expect(response.body).to match(expected_body)
      end
    end

    describe "#create_folder" do
      subject(:response) { session.create_folder(folder: folder) }

      let(:attachments) { [json_attachment, xml_attachment, pdf_attachment] }
      let(:cases) { [build(:hubee_case)] }
      let(:folder) { build(:hubee_folder, attachments: attachments, cases: cases) }
      let(:json_attachment) { build(:hubee_attachment, :with_file) }
      let(:pdf_attachment) { build(:hubee_attachment, :with_file, file_name: "quotient_familial_Heinemeier_Hansson_David.pdf", mime_type: "application/pdf", file_size: 3079) }
      let(:xml_attachment) { build(:hubee_attachment, :with_file, file_name: "FormulaireQF.xml", mime_type: "application/xml", file_size: 1543) }

      context "when the folder is succesfully created" do
        let(:expected_body) do
          a_hash_including(
            "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            "attachments" => array_including(
              a_hash_including(
                "id" => "a66abb0c-52d1-4e50-9195-22526fb7ce92"
              ),
              a_hash_including(
                "id" => "a66abb0c-52d1-4e50-9195-22526fb7ce93"
              ),
              a_hash_including(
                "id" => "a66abb0c-52d1-4e50-9195-22526fb7ce94"
              )
            )
          )
        end

        before do
          stub_hubee_create_folder
        end

        it { is_expected.to be_a_success }

        it "returns the created the folder" do
          expect(response.body).to match(expected_body)
        end
      end

      context "when hubee returns an error" do
        before do
          stub_hubee_create_folder_with_error
        end

        it { is_expected.not_to be_a_success }

        it "sends a message to sentry" do
          expect(Sentry).to receive(:capture_message).with(
            "Hubee Error 500 on POST /teledossiers/v1/folders",
            anything
          )
          response
        end
      end
    end

    describe "#delete_folder" do
      subject(:response) { session.delete_folder(folder_id: folder_id) }

      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the folder is succesfully deleted" do
        before do
          stub_hubee_delete_folder
        end

        it { is_expected.to be_a_success }

        it "deletes the folder" do
          expect(response.code).to eq(204)
        end
      end
    end

    describe "#delete_notification" do
      subject(:response) { session.delete_notification(notification_id: notification_id) }

      let(:notification_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the notification is succesfully deleted" do
        before do
          stub_hubee_delete_notification
        end

        it { is_expected.to be_a_success }

        it "deletes the notification" do
          expect(response.code).to eq(204)
        end
      end
    end

    describe "#event" do
      subject(:response) { session.event(id:, case_id:) }

      let(:id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
      let(:case_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the event is succesfully retrieved" do
        before do
          stub_hubee_event
        end

        it { is_expected.to be_a_success }

        it "retrieves the event" do
          expect(response.body).to include("id" => "905055ea-ed37-4556-9db6-97ba89fcb91f")
        end
      end
    end

    describe "#mark_folder_complete" do
      subject(:response) { session.mark_folder_complete(folder_id: folder_id) }

      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the folder is succesfully marked as complete" do
        before do
          stub_hubee_mark_folder_complete
        end

        it { is_expected.to be_a_success }

        it "marks the folder as complete" do
          expect(response.code).to eq(204)
        end
      end
    end

    describe "#notifications" do
      subject(:response) { session.notifications }

      before do
        stub_hubee_notifications
      end

      let(:expected_response) do
        array_including(
          a_hash_including(
            "caseId" => "3fa85f64-5717-4562-b3fc-2c963f66afa",
            "eventId" => "3fa85f64-5717-4562-b3fc-2c963f66afa",
            "processCode" => "FormulaireQF",
            "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa"
          )
        )
      end

      it { is_expected.to be_a_success }

      it "returns the notifications" do
        expect(response.body).to match(expected_response)
      end
    end

    describe "#update_event" do
      subject(:response) { session.update_event(id:, case_id:) }

      let(:id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
      let(:case_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the event is succesfully updated" do
        before do
          stub_hubee_update_event
        end

        it { is_expected.to be_a_success }

        it "updates the event" do
          expect(response.code).to eq(204)
        end
      end
    end

    describe "#upload_attachment" do
      subject(:response) { session.upload_attachment(attachment: attachment, folder_id: folder_id) }

      let(:attachment) { build(:hubee_attachment, :with_file, id: "a66abb0c-52d1-4e50-9195-22526fb7ce92") }
      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the attachment is succesfully uploaded" do
        before do
          stub_hubee_upload_attachment
        end

        it { is_expected.to be_a_success }

        it "uploads the attachment" do
          expect(response.code).to eq(204)
        end
      end
    end
  end
end
