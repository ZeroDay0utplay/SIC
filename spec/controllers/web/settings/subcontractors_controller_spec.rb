require "rails_helper"

RSpec.describe Web::Settings::SubcontractorsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let(:subcontractor) { create(:subcontractor, company: company) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns @subcontractors and renders the index template" do
      get :index
      expect(assigns(:subcontractors)).to be_a(ActiveRecord::Relation)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #get_agents" do
    it "assigns @agents and renders the agent modal" do
      get :get_agents, params: {id: subcontractor.id}, format: :turbo_stream
      expect(assigns(:agents)).to be_a(ActiveRecord::Relation)
      expect(response).to render_template("settings/subcontractors/_agent_modal")
    end
  end

  describe "GET #search_agents" do
    it "assigns @agents and renders the agent list" do
      get :search_agents, params: {id: subcontractor.id, q: {email_cont: "example"}}, format: :turbo_stream
      expect(assigns(:agents)).to be_a(ActiveRecord::Relation)
      expect(assigns(:count)).to be_an(Integer)
      expect(response).to render_template("settings/subcontractors/_agent_list")
    end
  end

  describe "GET #new" do
    it "assigns @subcontractor and renders the new template" do
      get :new
      expect(assigns(:subcontractor)).to be_a_new(Subcontractor)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new subcontractor and redirects to add_agents" do
        valid_params = {company_name: "Company", manager: "Manager", email: "email@example.com"}
        post :create, params: {subcontractor: valid_params}
        expect(assigns(:subcontractor)).to be_persisted
        expect(response).to redirect_to(add_agents_settings_subcontractor_path(assigns(:subcontractor)))
      end
    end

    context "with invalid parameters" do
      it "does not create a new subcontractor and renders the new template" do
        invalid_params = {company_name: "", manager: "", email: "invalid"}
        post :create, params: {subcontractor: invalid_params}
        expect(assigns(:subcontractor)).not_to be_persisted
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns @subcontractor and renders the edit template" do
      get :edit, params: {id: subcontractor.id}
      expect(assigns(:subcontractor)).to eq(subcontractor)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the subcontractor and redirects to add_agents" do
        patch :update, params: {id: subcontractor.id, subcontractor: {company_name: "IDEO Groupe"}}
        expect(subcontractor.reload.company_name).to eq("IDEO Groupe")
        expect(response).to redirect_to(add_agents_settings_subcontractor_path(subcontractor))
      end
    end

    context "with invalid parameters" do
      it "does not update the subcontractor and renders the edit template" do
        patch :update, params: {id: subcontractor.id, subcontractor: {company_name: ""}}
        expect(subcontractor.reload.company_name).not_to eq("")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET #add_agents" do
    it "assigns @subcontractor_agent and @agents and renders the add_agents template" do
      get :add_agents, params: {id: subcontractor.id}
      expect(assigns(:subcontractor_agent)).to be_a_new(SubcontractorAgent)
      expect(assigns(:agents)).to be_an(ActiveRecord::Relation)
      expect(response).to render_template(:add_agents)
    end
  end

  describe "POST #create_agent" do
    context "with valid parameters" do
      it "creates a new agent and renders the agent partial" do
        valid_params = {first_name: "John", last_name: "Doe", email: "john@example.com"}
        post :create_agent, params: {id: subcontractor.id, subcontractor_agent: valid_params}, format: :turbo_stream
        expect(assigns(:subcontractor_agent)).to be_persisted
        expect(response).to render_template("settings/subcontractors/_agent")
      end
    end

    context "with invalid parameters" do
      it "does not create an agent and renders the add_agents template" do
        invalid_params = {first_name: "", last_name: "", email: "invalid"}
        post :create_agent, params: {id: subcontractor.id, subcontractor_agent: invalid_params}
        expect(assigns(:subcontractor_agent)).not_to be_persisted
        expect(response).to render_template(:add_agents)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the subcontractor and redirects to the subcontractors path" do
      subcontractor = create(:subcontractor)
      delete :destroy, params: {id: subcontractor.id}, format: :turbo_stream
      expect(Subcontractor.exists?(subcontractor.id)).to be_falsey
    end
  end
end
