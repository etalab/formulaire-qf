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
      subject(:active_subscriptions) { session.active_subscriptions }

      before do
        stub_hubee_active_subscriptions
      end

      let(:expected_response) do
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

      it "returns the active subscriptions" do
        expect(active_subscriptions).to match(expected_response)
      end
    end

    describe "#create_folder" do
      subject(:create_folder) { session.create_folder(folder: folder) }

      let(:attachments) { [json_attachment, xml_attachment, pdf_attachment] }
      let(:cases) { [build(:hubee_case)] }
      let(:json_attachment) { build(:hubee_attachment, :with_file) }
      let(:xml_attachment) { build(:hubee_attachment, :with_file, file_name: "FormulaireQF.xml", mime_type: "application/xml", file_size: 1543) }
      let(:pdf_attachment) { build(:hubee_attachment, :with_file, file_name: "quotient_familial_Heinemeier_Hansson_David.pdf", mime_type: "application/pdf", file_size: 3079) }

      let(:folder) { build(:hubee_folder, attachments: attachments, cases: cases) }

      context "when the folder is succesfully created" do
        before do
          stub_hubee_create_folder
        end

        it "fills in the ids from the response" do
          expect(create_folder).to have_attributes(id: "3fa85f64-5717-4562-b3fc-2c963f66afa6", attachments: [an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce92"), an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce93"), an_object_having_attributes(id: "a66abb0c-52d1-4e50-9195-22526fb7ce94")])
        end
      end
    end

    describe "#delete_folder" do
      subject(:delete_folder) { session.delete_folder(folder_id: folder_id) }

      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the folder is succesfully deleted" do
        before do
          stub_hubee_delete_folder
        end

        it "deletes the folder" do
          expect(delete_folder).to have_attributes({})
        end
      end
    end

    describe "#delete_notification" do
      subject(:delete_notification) { session.delete_notification(notification_id: notification_id) }

      let(:notification_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the notification is succesfully deleted" do
        before do
          stub_hubee_delete_notification
        end

        it "deletes the notification" do
          expect(delete_notification).to have_attributes({})
        end
      end
    end

    describe "#event" do
      subject(:event) { session.event(id:, case_id:) }

      let(:id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
      let(:case_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the event is succesfully retrieved" do
        before do
          stub_hubee_event
        end

        it "retrieves the event" do
          expect(event).to include("id" => "905055ea-ed37-4556-9db6-97ba89fcb91f")
        end
      end
    end

    describe "#update_event" do
      subject(:update_event) { session.update_event(id:, case_id:) }

      let(:id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
      let(:case_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the event is succesfully updated" do
        before do
          stub_hubee_update_event
        end

        it "updates the event" do
          expect(update_event).to have_attributes({})
        end
      end
    end

    describe "#upload_attachment" do
      subject(:upload_attachment) { session.upload_attachment(attachment: attachment, folder_id: folder_id) }

      let(:attachment) { build(:hubee_attachment, :with_file, id: "a66abb0c-52d1-4e50-9195-22526fb7ce92") }
      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the attachment is succesfully uploaded" do
        before do
          stub_hubee_upload_attachment
        end

        it "uploads the attachment" do
          expect(upload_attachment).to have_attributes({})
        end
      end
    end

    describe "#mark_folder_complete" do
      subject(:mark_folder_complete) { session.mark_folder_complete(folder_id: folder_id) }

      let(:folder_id) { "3fa85f64-5717-4562-b3fc-2c963f66afa6" }

      context "when the folder is succesfully marked as complete" do
        before do
          stub_hubee_mark_folder_complete
        end

        it "marks the folder as complete" do
          expect(mark_folder_complete).to have_attributes({})
        end
      end
    end

    describe "#notifications" do
      subject(:notifications) { session.notifications }

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

      it "returns the notifications" do
        expect(notifications).to match(expected_response)
      end
    end
  end
end
