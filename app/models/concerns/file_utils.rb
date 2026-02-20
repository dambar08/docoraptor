module FileUtils
  extend ActiveSupport::Concern

  private

  def convert_docx_to_pdf(docx_path, pdf_path)
    raise "Missing source file: #{docx_path}" unless File.exist?(docx_path)

    Libreconv.convert(docx_path, pdf_path)
  rescue => e
    Rails.logger.error("[Document] PDF conversion failed: #{e.full_message}")
    raise
  end

  def template_path
    name = slug || template_name
    path = Rails.root.join("templates", "#{name}.docx")

    raise "Template not found: #{path}" unless File.exist?(path)

    path
  end

  def make_temp_file(filename)
    path = Rails.root.join("tmp", "documents", filename)
    FileUtils.mkdir_p(path.dirname)
    path
  end
end
