module HubEE
  class Attachment < Data.define(:id, :file, :file_content, :file_name, :file_size, :mime_type, :recipients, :type)
    def initialize(file_content:, file_name:, mime_type:, recipients:, type:, id: nil, file: nil, file_size: nil)
      super
    end

    def [](key)
      public_send(key)
    end

    def close_file
      return unless file

      file.close
    end

    def write(file:)
      file.write(file_content)
    end
  end
end
