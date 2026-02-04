require 'rails_helper'

RSpec.describe "Pings", type: :request do
  describe "GET /up" do
    it "returns html up" do
      get "/up"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("background-color: green")
    end

    it "returns json up" do
      get "/up", headers: { "ACCEPT" => "application/json" }

      json = JSON.parse(response.body)
      expect(json["status"]).to eq("up")
    end

    context "when exception is raised" do
      before do
        allow_any_instance_of(PingController)
          .to receive(:render_up)
          .and_raise(StandardError)
      end

      it "returns html down" do
        get "/up"

        expect(response).to have_http_status(500)
        expect(response.body).to include("background-color: red")
      end

      it "returns json down" do
        get "/up", headers: { "ACCEPT" => "application/json" }

        json = JSON.parse(response.body)
        expect(response).to have_http_status(500)
        expect(json["status"]).to eq("down")
      end
    end
  end
end
