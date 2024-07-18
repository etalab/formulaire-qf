require_relative "../provider_stubs"

module ProviderStubs::HubEE
  def stub_hubee
    stub_hubee_token
    stub_hubee_create_folder
    stub_hubee_upload_attachment
    stub_hubee_mark_folder_complete
    stub_hubee_delete_folder
    stub_hubee_active_subscriptions
  end

  def stub_hubee_token(access_token: "access_token_123")
    stub_request(:post, "https://auth.bas.hubee.numerique.gouv.fr/oauth2/token")
      .to_return(
        status: 200,
        body: {"access_token" => access_token}.to_json,
        headers: {}
      )
  end

  def stub_hubee_active_subscriptions
    payload = [
      {
        "accessMode" => "API",
        "activateDateTime" => "2024-04-18T22:00:00.000+00:00",
        "creationDateTime" => "2024-04-19T09:11:14.100+00:00",
        "datapassId" => 0,
        "delegationActor" => {"branchCode" => nil, "companyRegister" => nil, "type" => nil},
        "email" => nil,
        "endDateTime" => nil,
        "id" => "a0179445-1e8b-46ff-8c1f-4b74d0498833",
        "localAdministrator" => {"email" => "contact-nhube@data.gouv.fr"},
        "notificationFrequency" => "Aucune",
        "processCode" => "FormulaireQF",
        "rejectDateTime" => nil,
        "rejectionReason" => nil,
        "status" => "Actif",
        "subscriber" => {
          "branchCode" => "01034",
          "companyRegister" => "21010034300016",
          "name" => "COMMUNE DE BELLEY",
          "type" => "SI",
        },
        "updateDateTime" => "2024-04-19T09:11:53.000+00:00",
        "validateDateTime" => "2024-04-19T09:11:13.900+00:00",
      },
      {
        "accessMode" => "PORTAIL",
        "activateDateTime" => "2024-04-18T22:00:00.000+00:00",
        "creationDateTime" => "2024-04-18T08:01:21.405+00:00",
        "datapassId" => 0,
        "delegationActor" => {"branchCode" => nil, "companyRegister" => nil, "type" => nil},
        "email" => nil,
        "endDateTime" => nil,
        "id" => "47b12d1c-8567-45f1-ac73-8c07c11f0a97",
        "localAdministrator" => {"email" => "majastres@yopmail.com"},
        "notificationFrequency" => "Aucune",
        "processCode" => "FormulaireQF",
        "rejectDateTime" => nil,
        "rejectionReason" => nil,
        "status" => "Actif",
        "subscriber" => {
          "branchCode" => "04107",
          "companyRegister" => "21040107100019",
          "name" => "COMMUNE DE MAJASTRES",
          "type" => "SI",
        },
        "updateDateTime" => "2024-06-14T15:27:43.000+00:00",
        "validateDateTime" => "2024-04-18T08:01:21.137+00:00",
      },
    ]

    stub_request(:get, "https://api.bas.hubee.numerique.gouv.fr/referential/v1/subscriptions?maxResult=5000&processCode=FormulaireQF&status=Actif")
      .to_return(
        status: 200,
        body: payload.to_json,
        headers: {}
      )
  end

  def stub_hubee_create_folder(names: "Heinemeier_Hansson_David")
    allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

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
            fileName: "quotient_familial_#{names}.pdf",
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

  def stub_hubee_create_folder_with_error
    allow(SecureRandom).to receive(:hex).and_return("abcdef1234567thiswontbeused")

    stub_request(:post, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/folders")
      .to_return(status: 500, body:  {
        error: "Something went wrong",
      }.to_json, headers: {})
  end

  def stub_hubee_notifications
    notifications = [
      {
        "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa",
        "caseId" => "3fa85f64-5717-4562-b3fc-2c963f66afa",
        "eventId" => "3fa85f64-5717-4562-b3fc-2c963f66afa",
        "processCode" => "FormulaireQF",
      },
    ]

    stub_request(:get, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/notifications")
      .with(query: hash_including("maxResult"))
      .to_return(status: 200, body: notifications.to_json)
  end

  def stub_hubee_delete_notification
    stub_request(:delete, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/notifications/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .to_return(status: 204, body: "", headers: {})
  end

  def stub_hubee_event
    payload = {
      "actionType" => "STATUS_UPDATE",
      "attachments" => [],
      "author" => "John Doe",
      "caseCurrentStatus" => "SENT",
      "caseNewStatus" => "SI_RECEIVED",
      "comment" => "",
      "createDateTime" => "2024-07-04T08:54:15.438+00:00",
      "id" => "905055ea-ed37-4556-9db6-97ba89fcb91f",
      "message" => "",
      "notification" => true,
      "partnerAttributes" => nil,
      "partnerInfo" => {
        "editorName" => "SOMEEDITOR",
        "applicationName" => "Portail",
        "softwareVersion" => "2.2.2",
      },
      "status" => "SENT",
      "transmitter" => {
        "type" => "SI",
        "branchCode" => "04107",
        "companyRegister" => "21040107100019",
      },
      "updateDateTime" => nil,
    }

    stub_request(:get, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/cases/3fa85f64-5717-4562-b3fc-2c963f66afa6/events/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .to_return(status: 200, body: payload.to_json, headers: {})
  end

  def stub_hubee_update_event
    stub_request(:patch, "https://api.bas.hubee.numerique.gouv.fr/teledossiers/v1/cases/3fa85f64-5717-4562-b3fc-2c963f66afa6/events/3fa85f64-5717-4562-b3fc-2c963f66afa6")
      .to_return(status: 204, body: "", headers: {})
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
