require "rails_helper"

RSpec.describe "LogRequest concern", type: :request do
  before do
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:error)
  end

  it "logs successful request" do
    get "/up"

    expect(Rails.logger).to have_received(:info).with(
      a_string_including(
        "method=GET",
        "path=/up",
        "status=200"
      )
    )
  end

  it "logs failed request" do
    # TODO
    skip "revisit later, bye"
    allow_any_instance_of(PingController)
      .to receive(:render_up)
      .and_raise(StandardError.new("boom"))

    get "/up"

    expect(response).to have_http_status(500)

    expect(Rails.logger).to have_received(:error).with(
      a_string_including(
        "REQ-ERROR",
        "boom",
        "path=/up"
      )
    )

    expect(Rails.logger).to have_received(:info).with(
      a_string_including("status=500")
    )
  end
end
