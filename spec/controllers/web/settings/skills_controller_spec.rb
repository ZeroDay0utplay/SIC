require "rails_helper"

RSpec.describe Web::Settings::SkillsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let!(:skill) { create(:skill, company: company) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns skills and renders the index template" do
      get :index
      expect(assigns(:skills)).to include(skill)
      expect(response).to render_template(:index)
    end

    it "responds with Turbo Stream" do
      get :index, format: :turbo_stream
      expect(response.content_type).to eq "text/vnd.turbo-stream.html; charset=utf-8"
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { {name: "Unique Skill Name"} }

      it "creates a new skill" do
        expect {
          post :create, params: {skill: valid_attributes}, format: :turbo_stream
          puts assigns(:skill).errors.full_messages if assigns(:skill).present?
        }.to change(Skill, :count).by(1)
      end

      it "responds with Turbo Stream" do
        post :create, params: {skill: valid_attributes}, format: :turbo_stream
        expect(response.content_type).to eq "text/vnd.turbo-stream.html; charset=utf-8"
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { {name: ""} }

      it "does not create a new skill" do
        expect {
          post :create, params: {skill: invalid_attributes}, format: :turbo_stream
        }.not_to change(Skill, :count)
      end
    end
  end

  describe "GET #check_name" do
    it "returns exists as true if the skill exists" do
      get :check_name, params: {name: skill.name}
      expect(JSON.parse(response.body)["exists"]).to be_truthy
    end

    it "returns exists as false if the skill does not exist" do
      get :check_name, params: {name: "NonExistentSkill"}
      expect(JSON.parse(response.body)["exists"]).to be_falsey
    end
  end

  describe "GET #edit" do
    it "assigns the requested skill to @skill" do
      get :edit, params: {id: skill.id}, format: :turbo_stream
      expect(assigns(:skill)).to eq(skill)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      let(:updated_name) { "Updated Skill Name" }

      it "updates the skill" do
        patch :update, params: {id: skill.id, skill: {name: updated_name}}
        skill.reload
        expect(skill.name).to eq(updated_name)
      end

      it "responds with Turbo Stream" do
        patch :update, params: {id: skill.id, skill: {name: updated_name}}, format: :turbo_stream
        expect(response.content_type).to eq "text/vnd.turbo-stream.html; charset=utf-8"
      end
    end

    context "with invalid attributes" do
      it "does not update the skill" do
        patch :update, params: {id: skill.id, skill: {name: ""}}
        skill.reload
        expect(skill.name).not_to eq("")
      end
    end
  end
end
