require "rails_helper"

RSpec.describe Web::Superadmin::CompaniesController, type: :controller do
  let(:user) { create(:superadmin) }
  let!(:company1) { create(:company) }
  let!(:company2) { create(:company) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all companies to @companies" do
      get :index
      expect(assigns(:companies)).to match_array([company1, company2])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
