require "rails_helper"

RSpec.describe Web::Settings::ContactsController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let!(:contact) { create(:contact, company: company) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "assigns contacts and renders the index template" do
      get :index
      expect(assigns(:contacts)).to include(contact)
      expect(response).to render_template(:index)
    end

    it "responds with turbo_stream format" do
      get :index, format: :turbo_stream
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "GET #new" do
    it "renders the new contact form" do
      get :new, format: :turbo_stream
      expect(assigns(:contact)).to be_a_new(Contact)
      expect(response).to render_template(partial: "web/settings/contacts/_form")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:contact) }

      it "creates a new contact and responds to turbo_stream" do
        expect {
          post :create, params: {contact: valid_attributes}, format: :turbo_stream
        }.to change(Contact, :count).by(1)

        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit contact form" do
      get :edit, params: {id: contact.id}, format: :turbo_stream
      expect(assigns(:contact)).to eq(contact)
      expect(response).to render_template(partial: "web/settings/contacts/_form")
    end
  end

  describe "PATCH/PUT #update" do
    it "updates the contact and responds with turbo_stream" do
      patch :update, params: {id: contact.id, contact: {first_name: "Updated Name"}}, format: :turbo_stream
      expect(contact.reload.first_name).to eq("Updated Name")
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the contact and updates the contact list" do
      expect {
        delete :destroy, params: {id: contact.id}, format: :turbo_stream
      }.to change(Contact, :count).by(-1)

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end
end
