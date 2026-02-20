module Pdf
  module Merge
    class PdfService
      include ActiveModel::Validations

      attr_reader :files, :file_urls, :filename

      validate :exactly_one_source_present
      validate :at_least_one_file
      validate :all_files_are_pdfs

      def initialize(files: [], file_urls: [], filename:)
        @files     = Array(files)
        @file_urls = Array(file_urls)
        @filename  = filename
      end

      def call
        return nil unless valid?
        with_merge do |pdf|
          pdf
        end
      end

      def files_to_merge
        file_urls.presence || files
      end

      def error_message
        errors.full_messages.to_sentence
      end

      private

      def with_merge
        pdf = PdfDocument.merge(files_to_merge)
        yield(pdf)
        pdf.filename = filename
        pdf
      end

      def exactly_one_source_present
        if files.present? && file_urls.present?
          errors.add(:base, "Provide either files or file_urls, not both")
        end
      end

      def at_least_one_file
        if files.blank? && file_urls.blank?
          errors.add(:base, "At least one file is required")
        end
      end

      def all_files_are_pdfs
        return if files_to_merge.blank?

        invalid = files_to_merge.reject { |file| pdf?(file) }

        if invalid.any?
          errors.add(:base, "All files must be PDF")
        end
      end

      def pdf?(file)
        valid_by_ext?(file) && valid_by_mime?(file)
      end

      def valid_by_ext?(file)
        return true unless file.respond_to?(:path)
        File.extname(file.path).casecmp(".pdf").zero?
      end

      def valid_by_mime?(file)
        return true unless file.respond_to?(:content_type)
        file.content_type == "application/pdf"
      end
    end
  end
end
