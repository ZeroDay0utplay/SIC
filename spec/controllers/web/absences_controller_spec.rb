require "rails_helper"

RSpec.describe Web::AbsencesController, type: :controller do
  let(:company) { create(:company) }
  let(:agent) { create(:agent, company: company) }
  let(:admin) { create(:admin, company: company) }
  let(:absence) { create(:absence, user: agent) }
  let(:valid_attributes) do
    {
      date_start: "2024-01-01",
      date_end: "2024-01-10",
      motif: "Vacation",
      type_absence: :personal_reason,
      user_id: agent.id,
      state: "pending"
    }
  end

  let(:invalid_attributes) do
    {
      date_start: nil,
      date_end: nil
    }
  end

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "renders the index template with all absences" do
      absence
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:absences)).to include(absence)
    end

    it "filters absences by state if state param is present" do
      get :index, params: {state: absence.state}
      expect(assigns(:absences)).to include(absence)
    end
  end

  describe "GET #new" do
    it "renders the new template via Turbo Stream" do
      get :new, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream].to_s
      expect(response.body).to include("remote_modal")
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new absence" do
        expect {
          post :create, params: {absence: valid_attributes}, format: :turbo_stream
        }.to change(Absence, :count).by(1)
      end

      it "renders the turbo_stream response" do
        post :create, params: {absence: valid_attributes}, format: :turbo_stream
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "does not create a new absence" do
        expect {
          post :create, params: {absence: invalid_attributes}, format: :turbo_stream
        }.not_to change(Absence, :count)
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template via Turbo Stream" do
      get :edit, params: {id: absence.id}, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream].to_s
      expect(response.body).to include("remote_modal")
    end
  end

  describe "PATCH #update" do
    context "with invalid parameters" do
      it "does not update the absence and renders the edit form" do
        original_date_start = absence.date_start
        patch :update, params: {id: absence.id, absence: {date_start: nil}}, format: :html
        absence.reload
        expect(absence.date_start).to eq(original_date_start)
        expect(response).to render_template(:edit)
      end

      it "renders the Turbo Stream response with the form" do
        patch :update, params: {id: absence.id, absence: {date_start: nil}}, format: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("remote_modal")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested absence" do
      absence
      expect {
        delete :destroy, params: {id: absence.id}
      }.to change(Absence, :count).by(-1)
    end
  end
end
