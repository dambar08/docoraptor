require "rails_helper"

RSpec.describe PdfDocument, type: :model do
  let(:tempfile) do
    tf = Tempfile.new([ "test", ".pdf" ])
    tf.write("PDFDATA")
    tf.rewind
    tf
  end

  describe "initialization" do
    it "assigns tempfile and default filename" do
      pdf = described_class.new(tempfile)

      expect(pdf.tempfile).to eq(tempfile)
      expect(pdf.filename).to end_with(".pdf")
    end

    it "uses provided filename" do
      pdf = described_class.new(tempfile, filename: "x.pdf")
      expect(pdf.filename).to eq("x.pdf")
    end
  end

  describe ".from_file" do
    it "wraps the file" do
      pdf = described_class.from_file(tempfile)
      expect(pdf.tempfile).to eq(tempfile)
    end
  end

  describe ".from_url" do
    it "downloads and wraps content" do
      io = StringIO.new("REMOTE")

      allow(URI).to receive(:open).and_return(io)

      pdf = described_class.from_url("http://x.com/a.pdf")

      expect(pdf.read).to eq("REMOTE")
    end
  end

  describe ".from_io" do
    it "copies IO into a new tempfile" do
      io = StringIO.new("DATA")

      pdf = described_class.from_io(io)

      expect(pdf.read).to eq("DATA")
      expect(pdf.tempfile).not_to eq(io)
    end
  end

  describe "#close" do
    it "closes and unlinks tempfile" do
      pdf = described_class.new(tempfile)
      path = tempfile.path

      pdf.close

      expect(File.exist?(path)).to be false
    end
  end

  describe "#encrypt" do
    let(:output_file) { Tempfile.new([ "out", ".pdf" ]) }

    before do
      prawn = double("PrawnDoc")

      allow(Prawn::Document).to receive(:new).and_return(prawn)
      allow(prawn).to receive(:encrypt_document)
      allow(prawn).to receive(:render_file)
    end

    it "runs through safe_process and returns new PdfDocument" do
      pdf = described_class.new(tempfile)

      result = pdf.encrypt("secret")

      expect(result).to be_a(PdfDocument)
      expect(Prawn::Document).to have_received(:new)
    end
  end

  describe ".merge" do
    let(:file1) { Tempfile.new([ "a", ".pdf" ]) }
    let(:file2) { Tempfile.new([ "b", ".pdf" ]) }

    let(:combine) { double("CombinePDF") }

    before do
      allow(CombinePDF).to receive(:new).and_return(combine)
      allow(CombinePDF).to receive(:load).and_return(double("Loaded"))
      allow(combine).to receive(:<<)
      allow(combine).to receive(:save)
    end

    it "merges files and returns PdfDocument" do
      result = described_class.merge([ file1, file2 ])

      expect(result).to be_a(PdfDocument)
      expect(CombinePDF).to have_received(:new)
      expect(combine).to have_received(:<<).twice
      expect(combine).to have_received(:save)
    end
  end

  describe ".safe_process" do
    it "returns PdfDocument on success" do
      input = tempfile

      result = described_class.safe_process(input) do |_in, out|
        out.write("OK")
      end

      expect(result).to be_a(PdfDocument)
      expect(result.read).to eq("OK")
    end

    it "cleans up output on error" do
      input = tempfile

      expect do
        described_class.safe_process(input) do |_in, _out|
          raise "boom"
        end
      end.to raise_error("boom")
    end
  end
end
