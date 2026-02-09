class Template < ApplicationRecord
  has_one_attached :file

  MAX_FILE_SIZE = 20.megabytes
  ALLOWED_TYPES = %w[
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.ms-excel
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    text/plain
  ].freeze

  validates :file,
            attached: true, # ActiveStorageValidations ensures presence
            content_type: ALLOWED_TYPES,  # ensures MIME type
            size: { less_than: MAX_FILE_SIZE }  # ensures max size

  validate :template_name_format

  private

  def template_name_format
    return if name.nil?

    unless name =~ /\A[\w\-. ]+\z/
      errors.add(:file, "has invalid filename")
    end
  end
end
