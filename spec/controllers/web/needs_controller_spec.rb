require "rails_helper"

RSpec.describe Web::NeedsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:company) { create(:company) }
  let(:client) { create(:client, company: company) }
  let(:prestation) { create(:prestation, company: company) }
  let(:contact) { create(:contact) }
  let(:agent_1) { create(:agent, company: company) }
  let(:agent_2) { create(:agent, company: company) }
  let(:agent_3) { create(:agent, company: company) }
  let(:client_contact) { create(:client_contact, client: client, contact: contact) }
  let(:intervention) { create(:intervention, client: client, company: company, admin: admin) }

  before do
    sign_in admin
    allow(Current).to receive(:company).and_return(company)
  end

  describe "GET #new" do
    context "when type is punctual" do
      it "initializes a punctual planning" do
        get :new, params: {type: "punctual"}
        expect(assigns(:planning)).to be_a(Punctual)
      end
    end

    context "when type is regular" do
      it "initializes a regular planning" do
        get :new, params: {type: "regular"}
        expect(assigns(:planning)).to be_a(Regular)
      end
    end

    context "when type is invalid" do
      it "initializes a default planning" do
        get :new, params: {type: "invalid"}
        expect(assigns(:planning)).to be_a(Planning)
      end
    end
  end

  describe "GET #get_interventions" do
    it "responds with turbo_stream and html formats" do
      get :get_interventions, params: {id: client.id, model: "client"}, format: :turbo_stream
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET #get_agents" do
    it "assigns agents for the current company" do
      get :get_agents, format: :turbo_stream
      expect(assigns(:agents)).to eq(Agent.current_company)
    end
  end
end
