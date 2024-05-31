class HubEE::CreateFolder < BaseInteractor
  before do
    context.session ||= HubEE::Api.session
  end

  def call
    context.folder = context.session.create_folder(folder: context.folder)
  end

  def rollback
    context.session.delete_folder(folder_id: context.folder.id)
  end
end
