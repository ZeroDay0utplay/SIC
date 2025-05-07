require "rails_helper"

RSpec.describe Web::Settings::EmailModelsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let!(:email_model) { create(:email_model, company: company) }
  let(:valid_params) do
    {
      subject: "Valid Subject",
      body: "Valid Body"
    }
  end
  let(:invalid_params) do
    {
      subject: nil,
      body: nil
    }
  end

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
      it "creates a new email_model and renders turbo_stream" do
        expect {
          post :create, params: {email_model: valid_params, company: company}, format: :turbo_stream
        }.to change(EmailModel, :count).by(1)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid parameters" do
      it "updates the email_model and redirects" do
        patch :update, params: {id: email_model.id, email_model: valid_params}
        expect(email_model.reload.subject).to eq(valid_params[:subject])
        expect(email_model.reload.body).to eq(valid_params[:body])
        expect(response).to redirect_to(settings_email_models_path)
      end
    end

    context "with invalid parameters" do
      it "renders the form with errors" do
        patch :update, params: {id: email_model.id, email_model: invalid_params}, format: :turbo_stream
        expect(response).to render_template(partial: "web/settings/email_models/_form")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the email_model and renders turbo_stream" do
      expect {
        delete :destroy, params: {id: email_model.id}, format: :turbo_stream
      }.to change(EmailModel, :count).by(-1)
      expect(response.content_type).to include(Mime[:turbo_stream].to_s)
    end
  end
end
