require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  describe "POST #create" do
    context "with valid credentials" do
      it "returns a valid authentication token" do
        post :create, params: {email: user.email, password: "password123"}
        expect(response).to have_http_status(:ok)
        expect(json_response["authentication_token"]).not_to be_nil
        expect(json_response["user"]["id"]).to eq(user.id)
      end
    end

    context "with invalid credentials" do
      it "returns an unauthorized error" do
        post :create, params: {email: user.email, password: "wrongpassword"}
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to eq("Invalid email or password")
      end

      it "returns an unauthorized error for non-existent user" do
        post :create, params: {email: "nonexistent@example.com", password: "password123"}
        expect(response).to have_http_status(:unauthorized)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is authenticated" do
      before do
        user.update(authentication_token: SecureRandom.hex(20))
        request.headers["Authorization"] = "Token #{user.authentication_token}"
      end

      it "clears the authentication token and returns a success message" do
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(json_response["message"]).to eq("Signed out successfully")
        expect(user.reload.authentication_token).to be_nil
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
