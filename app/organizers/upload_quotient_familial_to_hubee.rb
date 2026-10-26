class UploadQuotientFamilialToHubEE < BaseOrganizer
  organize PrepareQuotientFamilialHubEEFolder,
    HubEE::PrepareAttachments,
    HubEE::CreateFolder,
    HubEE::UploadAttachments,
    HubEE::MarkFolderComplete,
    HubEE::CleanAttachments

  around do |interactor|
    interactor.call
  rescue HubEE::Api::Error => e
    Sentry.capture_exception(e)
    context.fail!
  end
end
