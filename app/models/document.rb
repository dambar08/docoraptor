class Document
  attr_reader :slug, :variables, :images, :filename, :upload

  include DocxDocument
  include FileUtils


  def initialize(slug:, variables: {}, images: {}, filename:)
    @slug      = slug
    @variables = variables.to_h
    @images    = images.to_h
    @filename  = filename
  end

  def render_pdf
    with_temp_files do |docx_path, pdf_path|
      render_docx(docx_path)
      convert_docx_to_pdf(docx_path, pdf_path)

      File.binread(pdf_path)
    end
  end

  private

  def with_temp_files
    docx_path = make_temp_file("#{SecureRandom.uuid}.docx")
    pdf_path  = make_temp_file(filename)

    yield(docx_path, pdf_path)
  ensure
    safe_cleanup(docx_path, pdf_path)
  end

  def safe_cleanup(*paths)
    FileUtils.rm_f(paths)
  rescue => e
    Rails.logger.error("[Document] cleanup failed: #{e.class}: #{e.message}")
  end
end
