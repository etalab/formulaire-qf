class Hubee::MarkFolderComplete < BaseInteractor
  def call
    context.session.mark_folder_complete(folder_id: context.folder.id)
  end
end
