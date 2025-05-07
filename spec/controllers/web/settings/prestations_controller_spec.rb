require "rails_helper"

RSpec.describe Web::Settings::PrestationsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }

  let!(:prestation) { create(:prestation, company: company) }
  let(:valid_params) do
    {
      name: "Valid Name",
      description: "Valid Description",
      unity: "Unit",
      type_prestation: :service,
      state: :free,
      company_id: company.id
    }
  end
  let(:invalid_params) do
    {
      name: nil,
      description: nil,
      unity: nil,
      type_prestation: nil,
      state: nil,
      company_id: company.id
    }
  end

  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    context "with HTML format" do
      it "responds successfully with HTTP status 200" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end

    context "with turbo_stream format" do
      it "responds with turbo_stream" do
        get :index, format: :turbo_stream
        expect(response.content_type).to include(Mime[:turbo_stream].to_s)
      end
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new prestation and renders turbo_stream" do
        expect {
          post :create, params: {prestation: valid_params, company: company}, format: :turbo_stream
        }.to change(Prestation, :count).by(1)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      it "updates the prestation and redirects" do
        patch :update, params: {id: prestation.id, prestation: valid_params}
        expect(prestation.reload.name).to eq(valid_params[:name])
        expect(response).to redirect_to(settings_prestations_path)
      end
    end

    context "with invalid parameters" do
      it "renders the form with errors" do
        patch :update, params: {id: prestation.id, prestation: invalid_params}, format: :turbo_stream
        expect(response).to render_template(partial: "web/settings/prestations/_form")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the prestation and renders turbo_stream" do
      expect {
        delete :destroy, params: {id: prestation.id}, format: :turbo_stream
      }.to change(Prestation, :count).by(-1)
      expect(response.content_type).to include(Mime[:turbo_stream].to_s)
    end
  end
end
