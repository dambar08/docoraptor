module Pdf
  module Merge
    class SecurePdfService < PdfService
      attr_reader :password

      def initialize(files: [], file_urls: [], filename:, password: nil)
        super(files: files, file_urls: file_urls, filename: filename)
        @password  = password
      end

      def call
        return nil unless valid?

        with_merge do |pdf|
          pdf.encrypt(password) if password.present?
          pdf
        end
      end
  end
end
