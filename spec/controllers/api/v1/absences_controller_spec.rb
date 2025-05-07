require "rails_helper"

RSpec.describe Api::V1::AbsencesController, type: :controller do
  let(:user) { create(:agent, password: "password123", password_confirmation: "password123") }
  let!(:absences) { create_list(:absence, 3, user: user) }

  describe "GET #index" do
    context "when user is authenticated" do
      before do
        user.update(authentication_token: SecureRandom.hex(20))
        request.headers["Authorization"] = "Token #{user.authentication_token}"
      end

      it "returns a list of absences for the current user" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response.size).to eq(3)
        expect(json_response.first["id"]).to eq(absences.first.id)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
