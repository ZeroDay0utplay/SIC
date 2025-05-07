require "rails_helper"

RSpec.describe Api::V1::ApplicationController, type: :controller do
  let(:user) { create(:user, authentication_token: "valid_token") }

  controller(Api::V1::ApplicationController) do
    def index
      render json: {message: "Success"}, status: :ok
    end
  end

  describe "authentication" do
    context "when a valid token is provided" do
      it "authenticates the user and allows access" do
        request.headers["Authorization"] = "Bearer #{user.authentication_token}"
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Success"}.to_json)
      end
    end

    context "when an invalid token is provided" do
      it "returns a 401 Unauthorized error" do
        request.headers["Authorization"] = "Bearer invalid_token"
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({error: "Unauthorized"}.to_json)
      end
    end

    context "when no token is provided" do
      it "returns a 401 Unauthorized error" do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({error: "Unauthorized"}.to_json)
      end
    end

    context "when the token is provided as a query parameter" do
      it "authenticates the user and allows access" do
        get :index, params: {authentication_token: user.authentication_token}
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({message: "Success"}.to_json)
      end
    end

    context "when the token is provided in an invalid format" do
      it "returns a 401 Unauthorized error" do
        request.headers["Authorization"] = "InvalidFormat"
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({error: "Unauthorized"}.to_json)
      end
    end
  end
end
