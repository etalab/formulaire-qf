class Hubee
  class CreateFolder < BaseOrganizer
    organize PrepareFolder, PrepareAttachments, Create, UploadAttachments, MarkFolderComplete, CleanAttachments
  end
end
