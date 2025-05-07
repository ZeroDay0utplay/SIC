require "rails_helper"

RSpec.describe Web::Settings::UsersController, type: :controller do
  let(:company) { create(:company) }
  let(:agent) { create(:agent, company: company) }
  let(:admin) { create(:admin, company: company) }

  let(:skills) { ["Ruby", "JavaScript"] }

  let(:valid_attributes) do
    {
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      role: "agent",
      password: "password"
    }
  end

  let(:invalid_attributes) do
    {
      email: nil,
      role: "agent",
      skills: []
    }
  end

  before do
    sign_in admin
  end

  describe "GET #new" do
    it "assigns a new user and renders the turbo stream" do
      get :new, params: {type: "administrators"}, format: :turbo_stream
      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:user).type).to eq("Admin")
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET #edit" do
    it "assigns the requested user and renders the turbo stream" do
      get :edit, params: {id: agent.id}, format: :turbo_stream
      expect(assigns(:user)).to eq(agent)
      expect(assigns(:user)).to be_a(User)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user and renders the turbo stream" do
        expect {
          post :create, params: {admin: valid_attributes}, format: :turbo_stream
        }.to change(User, :count).by(1)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user and renders errors" do
        expect {
          post :create, params: {admin: invalid_attributes}, format: :turbo_stream
        }.not_to change(User, :count)
        expect(response).to render_template("settings/users/_new_user_modal")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the user and renders the turbo stream" do
        patch :update, params: {id: agent.id, admin: {email: "new@example.com"}}, format: :turbo_stream
        expect(agent.reload.email).to eq("new@example.com")
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        patch :update, params: {id: agent.id, admin: {email: nil}}, format: :turbo_stream
        expect(agent.reload.email).not_to eq(nil)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user and renders the turbo stream" do
      user = create(:user, role: :agent, company: company)
      expect {
        delete :destroy, params: {id: user.id}, format: :turbo_stream
      }.to change(User, :count).by(-1)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "PATCH #activate" do
    it "toggles the user activation status" do
      agent.update(active: false)
      patch :activate, params: {id: agent.id}, format: :turbo_stream
      expect(agent.reload.active).to be_truthy
      patch :activate, params: {id: agent.id}, format: :turbo_stream
      expect(agent.reload.active).to be_falsey
    end
  end

  describe "GET #agents" do
    it "filters agents based on skills and status" do
      skill = create(:skill, name: "Ruby")
      agent.skills << skill
      agent.update(active: true)

      get :agents, params: {skills: [skill.id], status: true}, format: :turbo_stream

      expect(assigns(:users).map(&:id)).to include(agent.id)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET #administrators" do
    it "lists all administrators" do
      get :administrators, format: :turbo_stream
      expect(assigns(:users)).to include(admin)
      expect(assigns(:users).first).to be_a(Admin)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET #confirm_activate" do
    it "renders the confirm activate modal" do
      agent.update(active: false)
      get :confirm_activate, params: {id: agent.id}, format: :turbo_stream
      expect(response).to render_template("shared/_confirm_activate_user")
    end

    it "renders the confirm disactivate modal when user is active" do
      agent.update(active: true)
      get :confirm_activate, params: {id: agent.id}, format: :turbo_stream
      expect(response).to render_template("shared/_confirm_disactivate_user")
    end
  end
end
