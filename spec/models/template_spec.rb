require 'rails_helper'

RSpec.describe Template, type: :model do
  include ActionDispatch::TestProcess::FixtureFile

  let(:valid_file) do
    fixture_file_upload("sample.pdf", "application/pdf")
  end

  let(:invalid_type_file) do
    fixture_file_upload("sample.exe", "application/octet-stream")
  end

  let(:large_file) do
    file = Tempfile.new(["big", ".pdf"])
    file.binmode
    file.write("a" * (Template::MAX_FILE_SIZE + 1))
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "application/pdf")
  end

  describe "validations" do
    it "is valid with a proper file" do
      template = Template.new(name: "Test")
      template.file.attach(valid_file)

      expect(template).to be_valid
    end

    it "is invalid without a file" do
      template = Template.new(name: "Test")

      expect(template).not_to be_valid
      expect(template.errors[:file]).to include("can't be blank")
    end

    it "rejects files larger than max size" do
      template = Template.new(name: "Big")
      template.file.attach(large_file)

      expect(template).not_to be_valid
      expect(template.errors[:file].join).to match("file size must be less than 20 MB (current size is 20 MB)")
    end

    it "rejects invalid content types" do
      template = Template.new(name: "Hack")
      template.file.attach(invalid_type_file)

      expect(template).not_to be_valid
      # default content_type message includes allowed types
      expect(template.errors[:file].join).to match(/has an invalid content type/)
    end
  end
end
