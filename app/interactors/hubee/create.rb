class Hubee::Create < BaseInteractor
  before do
    context.session ||= Hubee::Api.session
  end

  def call
    context.folder = context.session.create_folder(folder: context.folder)
  end

  def rollback
    context.session.delete_folder(folder_id: context.folder.id)
  end
end
