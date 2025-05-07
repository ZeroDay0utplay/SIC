require "rails_helper"

RSpec.describe Web::Settings::MentionLegalsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }

  let!(:mention_legal) { create(:mention_legal, name: "Auer Inc", description: "Sample description") }
  let(:valid_attributes) { {name: "New Mention", description: "A new description"} }
  let(:invalid_attributes) { {name: "", description: ""} }

  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns mention_legals and renders the index view" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:mention_legals)).to eq([mention_legal])
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns a new MentionLegal and renders the new form" do
      get :new, format: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(assigns(:mention_legal)).to be_a_new(MentionLegal)
      expect(response.body).to include("remote_modal")
    end
  end

  describe "GET #edit" do
    it "assigns the requested MentionLegal and renders the edit form" do
      get :edit, params: {id: mention_legal.id}, format: :turbo_stream
      expect(response).to have_http_status(:ok)
      expect(assigns(:mention_legal)).to eq(mention_legal)
      expect(response.body).to include("remote_modal")
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new MentionLegal and renders success Turbo Stream" do
        expect {
          post :create, params: {mention_legal: valid_attributes}, format: :turbo_stream
        }.to change(MentionLegal, :count).by(1)
        expect(assigns(:mention_legal)).to be_persisted
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with invalid parameters" do
      it "does not create a new MentionLegal and re-renders the new form" do
        expect {
          post :create, params: {mention_legal: invalid_attributes}, format: :turbo_stream
        }.not_to change(MentionLegal, :count)
        expect(assigns(:mention_legal).errors).not_to be_empty
        expect(response).to render_template("settings/mention_legals/_new_mention_legal_modal")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the requested MentionLegal and renders Turbo Stream" do
        patch :update, params: {id: mention_legal.id, mention_legal: {name: "Updated Name"}}, format: :turbo_stream
        expect(mention_legal.reload.name).to eq("Updated Name")
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with invalid parameters" do
      it "does not update the MentionLegal and re-renders the edit form" do
        patch :update, params: {id: mention_legal.id, mention_legal: invalid_attributes}, format: :turbo_stream
        expect(mention_legal.reload.name).not_to eq("")
        expect(response).to render_template("settings/mention_legals/_edit_mention_legal_modal")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested MentionLegal and renders Turbo Stream" do
      expect {
        delete :destroy, params: {id: mention_legal.id}, format: :turbo_stream
      }.to change(MentionLegal, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end
end
