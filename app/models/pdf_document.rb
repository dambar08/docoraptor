require "open-uri"

class PdfDocument
  attr_reader :tempfile
  attr_accessor :filename

  delegate :read, to: :tempfile

  def initialize(tempfile, filename: nil)
    @tempfile = tempfile
    @filename = filename || "#{SecureRandom.uuid}.pdf"
  end

  # ---------- factories ----------

  def self.from_file(file)
    new(file)
  end

  def self.from_url(url)
    io = URI.open(url)
    from_io(io)
  end

  def self.from_io(io)
    tf = Tempfile.create(["pdf", ".pdf"])
    File.binwrite(tf.path, io.read)
    new(tf)
  end

  # ---------- lifecycle ----------

  def close
    tempfile&.close
    tempfile&.unlink
  end

  # ---------- operations ----------

  def encrypt(password)
    self.class.safe_process(tempfile) do |input, output|
      pdf = Prawn::Document.new(template: input.path)
      pdf.encrypt_document(
        owner_password: SecureRandom.hex(16),
        user_password: password,
        permissions: { modify_contents: false, modify_annotations: false }
      )
      pdf.render_file(output.path)
    end
  end

  # ---------- class ops ----------

  def self.merge(documents)
    inputs = documents.map do |doc|
      doc.is_a?(PdfDocument) ? doc : from_file(doc)
    end

    safe_process(inputs.map(&:tempfile)) do |files, output|
      pdf = CombinePDF.new
      files.each do |file|
        pdf << CombinePDF.load(file.path, allow_optional_content: true)
      end
      pdf.save(output.path)
    end
  end

  # ---------- infra ----------

  def self.safe_process(inputs)
    output = Tempfile.create(["pdf_output", ".pdf"])
    yield(inputs, output)
    new(output)
  rescue
    output.close
    output.unlink
    raise
  end
end
