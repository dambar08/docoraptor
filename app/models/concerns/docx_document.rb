module DocxDocument
  extend ActiveSupport::Concern

  def render_docx(path)
    data = build_docx_buffer
    File.binwrite(path, data)
  end

  protected

  def template_path
    path = Rails.root.join("templates", "#{slug}.docx")
    raise "Template not found: #{path}" unless File.exist?(path)
    path
  end

  def build_docx_buffer
    templater = DocxTemplater.new(convert_newlines: false)

    buffer = templater.replace_file_with_content(
      template_path.to_s,
      variables
    )

    images.any? ? replace_images(buffer, images) : buffer
  end

  def images
    {}
  end

  # replaces images inside docx zip safely
  def replace_images(buffer, image_map)
    Tempfile.create([ "docx", ".docx" ]) do |tmp|
      File.binwrite(tmp.path, buffer.string)

      Zip::File.open(tmp.path) do |zip|
        Zip::OutputStream.write_buffer do |out|
          zip.each do |entry|
            out.put_next_entry(entry.name)

            if replaceable_image?(entry, image_map)
              out.write decode_image(image_map[image_name(entry)])
            else
              out.write entry.get_input_stream.read
            end
          end
        end
      end
    end
  end

  private

  def replaceable_image?(entry, image_map)
    entry.name.start_with?("word/media/") &&
      image_map.key?(image_name(entry))
  end

  def image_name(entry)
    entry.name.delete_prefix("word/media/")
  end

  def decode_image(data)
    Base64.decode64(data)
  rescue => e
    Rails.logger.error("[Docx] Invalid base64 image: #{e.message}")
    raise
  end
end
