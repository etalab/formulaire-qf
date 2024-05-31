require_relative "../provider_stubs"

module ProviderStubs::HubEE
  def stub_hubee_token(access_token: "access_token_123")
    stub_request(:post, "https://auth.bas.hubee.numerique.gouv.fr/oauth2/token")
      .with(
        body: '{"scope":"OSL","grant_type":"client_credentials"}',
        headers: {
          "Authorization" => "Basic bm90X2FfcmVhbF9pZDpub3RfYV9yZWFsX3NlY3JldA==",
          "Content-Type" => "application/json",
          "Host" => "auth.bas.hubee.numerique.gouv.fr",
        }
      )
      .to_return(
        status: 200,
        body: {"access_token" => access_token}.to_json,
        headers: {}
      )
  end

  def stub_hubee_create_folder(access_token: "access_token_123")
    stub_request(:post, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders")
      .with(
        body: '{"processCode":"FormulaireQF","externalId":"Formulaire-QF-ABCDEF1234567","applicant":{"firstName":"David","lastName":"Heinemeier Hansson"},"cases":[{"recipient":{"companyRegister":"123456789","branchCode":"1234","type":"SI"},"externalId":"Formulaire-QF-ABCDEF1234567-01"}],"attachments":[{"fileName":"FormulaireQF.json","type":"FormulaireQF","size":22,"mimeType":"application/json","recipients":["Formulaire-QF-ABCDEF1234567-01"]}]}',
        headers: {
          "Authorization" => "Bearer #{access_token}",
          "Content-Type" => "application/json",
        }
      )
      .to_return(status: 200, body:  {
        id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        globalStatus: "HUBEE_RECEIVED",
        processCode: "FormulaireQF",
        createDateTime: "2024-05-22T13:36:01.781Z",
        closeDateTime: "2024-05-22T13:36:01.781Z",
        applicant: {
          firstName: "David",
          lastName: "Heinemeier Hansson",
        },
        externalId: "Formulaire-QF-ABCDEF1234567",
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
            externalId: "Formulaire-QF-ABCDEF1234567-01",
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
              "Formulaire-QF-ABCDEF1234567-01",
            ],
          },
        ],
      }.to_json, headers: {})
  end

  def stub_hubee_upload_attachment(access_token: "access_token_123")
    stub_request(:put, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6/attachments/a66abb0c-52d1-4e50-9195-22526fb7ce92")
      .with(
        body: '{"first_name":"David"}',
        headers: {
          "Authorization" => "Bearer #{access_token}",
          "Content-Length" => "22",
          "Content-Type" => "application/octet-stream",
        }
      )
      .to_return(status: 204, body: "", headers: {})
  end

  def stub_hubee_mark_folder_complete(access_token: "access_token_123")
    stub_request(:patch, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .with(
        body: '{"globalStatus":"HUBEE_COMPLETED"}'
      )
      .to_return(status: 204, body: "", headers: {})
  end

  def stub_hubee_delete_folder(access_token: "access_token_123")
    stub_request(:delete, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .with(
        headers: {
          "Authorization" => "Bearer access_token_123",
          "Content-Type" => "application/json",
          "Host" => "api.bas.hubee.numerique.gouv.fr",
        }
      )
      .to_return(status: 204, body: "", headers: {})
  end
end
