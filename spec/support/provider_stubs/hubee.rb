require_relative "../provider_stubs"

module ProviderStubs::HubEE
  def stub_hubee
    stub_hubee_token
    stub_hubee_create_folder
    stub_hubee_upload_attachment
    stub_hubee_mark_folder_complete
  end

  def stub_hubee_token(access_token: "access_token_123")
    stub_request(:post, "https://auth.bas.hubee.numerique.gouv.fr/oauth2/token")
      .to_return(
        status: 200,
        body: {"access_token" => access_token}.to_json,
        headers: {}
      )
  end

  def stub_hubee_create_folder
    stub_request(:post, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders")
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
            size: 683,
            mimeType: "application/json",
            recipients: [
              "Formulaire-QF-ABCDEF1234567-01",
            ],
          },
          {
            id: "a66abb0c-52d1-4e50-9195-22526fb7ce93",
            status: "PENDING",
            fileName: "FormulaireQF.xml",
            type: "FormulaireQF",
            size: 1543,
            mimeType: "application/xml",
            recipients: [
              "Formulaire-QF-ABCDEF1234567-01",
            ],
          },
          {
            id: "a66abb0c-52d1-4e50-9195-22526fb7ce94",
            status: "PENDING",
            fileName: "quotient_familial_Heinemeier_Hansson_David.pdf",
            type: "FormulaireQF",
            size: 3079,
            mimeType: "application/pdf",
            recipients: [
              "Formulaire-QF-ABCDEF1234567-01",
            ],
          },
        ],
      }.to_json, headers: {})
  end

  def stub_hubee_upload_attachment
    stub_request(:put, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6/attachments/a66abb0c-52d1-4e50-9195-22526fb7ce92")
      .to_return(status: 204, body: "", headers: {})

    stub_request(:put, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6/attachments/a66abb0c-52d1-4e50-9195-22526fb7ce93")
      .to_return(status: 204, body: "", headers: {})

    stub_request(:put, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6/attachments/a66abb0c-52d1-4e50-9195-22526fb7ce94")
      .to_return(status: 204, body: "", headers: {})
  end

  def stub_hubee_mark_folder_complete
    stub_request(:patch, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .to_return(status: 204, body: "", headers: {})
  end

  def stub_hubee_delete_folder
    stub_request(:delete, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .to_return(status: 204, body: "", headers: {})
  end
end
