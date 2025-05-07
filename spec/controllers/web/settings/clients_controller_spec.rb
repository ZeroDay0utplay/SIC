require "rails_helper"

RSpec.describe Web::Settings::ClientsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let(:client) { create(:client, :particular, company: company) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns @clients and @count" do
      get :index
      expect(assigns(:clients)).to include(client)
      expect(response).to render_template(:index)
    end

    it "responds successfully with HTML format" do
      get :index, format: :html
      expect(response).to have_http_status(:ok)
    end

    it "responds successfully with Turbo Stream format" do
      get :index, format: :turbo_stream
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "assigns a new Client to @client" do
      get :new
      expect(assigns(:client)).to be_a_new(Client)
    end
  end

  describe "GET #edit" do
    it "assigns the requested client to @client" do
      get :edit, params: {id: client.id}
      expect(assigns(:client)).to eq(client)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new client and redirects to index path" do
        expect {
          post :create, params: {client: attributes_for(:client)}
        }.to change(Client, :count).by(1)
        expect(response).to redirect_to(settings_clients_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the client and renders :new with unprocessable status" do
        post :create, params: {client: {name: nil}}, format: :turbo_stream

        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("flash_messages")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the client and redirects to contacts path with Turbo Stream format" do
        patch :update, params: {id: client.id, client: {name: "Updated Name"}}, format: :turbo_stream
        expect(assigns(:client).name).to eq("Updated Name")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      it "does not update the client and renders :edit with unprocessable status" do
        patch :update, params: {id: client.id, client: {name: nil}}
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:client_to_delete) { create(:client, company: company) }
    let!(:other_client) { create(:client, company: company) }

    it "deletes the client" do
      expect {
        delete :destroy, params: {id: client_to_delete.id}, format: :turbo_stream
      }.to change(Client, :count).by(-1)
    end
  end
end
