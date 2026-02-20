# spec/services/pdf/merge/pdf_service_spec.rb
require "rails_helper"

RSpec.describe Pdf::Merge::PdfService do
  let(:filename) { "merged.pdf" }

  let(:pdf_file) do
    double(
      path: "/tmp/a.pdf",
      content_type: "application/pdf"
    )
  end

  let(:non_pdf_file) do
    double(
      path: "/tmp/a.txt",
      content_type: "text/plain"
    )
  end

  let(:merged_pdf) do
    double("MergedPdf", filename: nil)
  end

  before do
    allow(PdfDocument).to receive(:merge).and_return(merged_pdf)
    allow(merged_pdf).to receive(:filename=)
  end

  describe "validations" do
    it "is invalid when both files and file_urls are provided" do
      service = described_class.new(
        files: [ pdf_file ],
        file_urls: [ "http://x.com/a.pdf" ],
        filename: filename
      )

      expect(service).not_to be_valid
      expect(service.error_message)
        .to eq("Provide either files or file_urls, not both")
    end

    it "is invalid when neither files nor file_urls are provided" do
      service = described_class.new(
        files: [],
        file_urls: [],
        filename: filename
      )

      expect(service).not_to be_valid
      expect(service.error_message)
        .to eq("At least one file is required")
    end

    it "is invalid when a non-pdf file is provided" do
      service = described_class.new(
        files: [ non_pdf_file ],
        filename: filename
      )

      expect(service).not_to be_valid
      expect(service.error_message)
        .to eq("All files must be PDF")
    end

    it "is valid with pdf files" do
      service = described_class.new(
        files: [ pdf_file ],
        filename: filename
      )

      expect(service).to be_valid
    end

    it "is valid with file_urls" do
      service = described_class.new(
        file_urls: [ "http://x.com/a.pdf" ],
        filename: filename
      )

      expect(service).to be_valid
    end
  end

  describe "#files_to_merge" do
    it "prefers file_urls over files" do
      service = described_class.new(
        files: [ pdf_file ],
        file_urls: [ "http://x.com/a.pdf" ],
        filename: filename
      )

      expect(service.files_to_merge).to eq([ "http://x.com/a.pdf" ])
    end

    it "returns files if no file_urls" do
      service = described_class.new(
        files: [ pdf_file ],
        filename: filename
      )

      expect(service.files_to_merge).to eq([ pdf_file ])
    end
  end

  describe "#call" do
    it "returns nil if invalid" do
      service = described_class.new(
        files: [],
        filename: filename
      )

      expect(service.call).to be_nil
      expect(PdfDocument).not_to have_received(:merge)
    end

    it "merges PDFs and sets filename" do
      service = described_class.new(
        files: [ pdf_file ],
        filename: filename
      )

      result = service.call

      expect(PdfDocument).to have_received(:merge).with([ pdf_file ])
      expect(merged_pdf).to have_received(:filename=).with(filename)
      expect(result).to eq(merged_pdf)
    end
  end

  describe "#pdf?" do
    it "returns true for valid pdf" do
      service = described_class.new(
        files: [ pdf_file ],
        filename: filename
      )

      expect(service.send(:pdf?, pdf_file)).to be true
    end

    it "returns false for invalid pdf" do
      service = described_class.new(
        files: [ non_pdf_file ],
        filename: filename
      )

      expect(service.send(:pdf?, non_pdf_file)).to be false
    end
  end
end
