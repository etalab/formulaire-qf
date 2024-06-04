class UploadQuotientFamilialToHubEE < BaseOrganizer
  organize PrepareQuotientFamilialHubEEFolder,
    HubEE::PrepareAttachments,
    HubEE::CreateFolder,
    HubEE::UploadAttachments,
    HubEE::MarkFolderComplete,
    HubEE::CleanAttachments
end
