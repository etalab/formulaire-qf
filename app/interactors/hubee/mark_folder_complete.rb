class HubEE::MarkFolderComplete < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    response = context.session.mark_folder_complete(folder_id: context.folder.id)
    context.fail!(message: response.body) unless response.success?
  end
end
