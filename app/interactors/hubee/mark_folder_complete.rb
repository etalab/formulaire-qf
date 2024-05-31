class HubEE::MarkFolderComplete < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    context.session.mark_folder_complete(folder_id: context.folder.id)
  end
end
