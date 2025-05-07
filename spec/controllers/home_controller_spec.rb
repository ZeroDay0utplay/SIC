require "rails_helper"

RSpec.describe HomeController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, role: :admin, company: company) }
  let(:admin) { FactoryBot.create(:user, role: :admin, company: company) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    before do
      get :index
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    it "returns a successful response" do
      expect(response).to have_http_status(:ok)
    end
  end
end
