require 'rails_helper'

RSpec.describe "Ping", type: :system do
  it "loads successfully" do
    visit root_path
    expect(page.status_code).to eq(200)
  end
end
