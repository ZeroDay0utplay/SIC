require "rails_helper"

RSpec.describe Web::Finances::QuotesController, type: :controller do
  let(:company) { create(:company) }
  let(:current_user) { create(:admin, company: company) }
  let(:client) { create(:client, company: company) }
  let(:heading) { create(:heading, client: client) }

  let(:other_company) { create(:company) }
  let(:other_user) { create(:admin, company: other_company) }
  let(:other_client) { create(:client, company: other_company) }
  let(:other_heading) { create(:heading, client: other_client) }

  let!(:quote) { create(:complete_quote, company: company, client: client, admin: current_user, heading: heading) }
  let!(:other_quote) { create(:quote, company: other_company, client: other_client, created_by: other_user.id, heading: other_heading) }

  let(:valid_params) { attributes_for(:quote, client_id: client.id, company_id: company.id, user_id: current_user.id) }
  let(:invalid_params) { attributes_for(:quote, client_id: nil) }

  before do
    sign_in current_user
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:current_company).and_return(company)
  end

  describe "GET #index" do
    context "when requesting HTML format" do
      it "assigns all company quotes as @quotes" do
        get :index
        expect(assigns(:quotes)).to include(quote)
        expect(assigns(:quotes)).not_to include(other_quote)
      end

      it "includes the required associations" do
        get :index
        expect(assigns(:quotes).first.association(:client)).to be_loaded
        expect(assigns(:quotes).first.association(:prestation)).to be_loaded
      end

      it "renders the HTML template" do
        get :index
        expect(response).to render_template(:index)
        expect(response.content_type).to eq("text/html; charset=utf-8")
      end

      it "only shows quotes from the current company" do
        get :index
        expect(assigns(:quotes)).to all(have_attributes(company_id: company.id))
      end
    end
  end

  describe "GET #new" do
    it "assigns a new quote as @quote" do
      get :new
      expect(assigns(:quote)).to be_a_new(Quote)
    end

    it "builds associated address" do
      get :new
      expect(assigns(:quote).address).to be_present
    end

    it "builds associated payment method" do
      get :new
      expect(assigns(:quote).payment_method).to be_present
    end

    it "builds associated commercial detail" do
      get :new
      expect(assigns(:quote).commercial_detail).to be_present
    end

    it "generates a reference" do
      get :new
      expect(assigns(:quote).reference).to be_present
    end
  end

  describe "GET #edit" do
    it "assigns the requested quote as @quote" do
      get :edit, params: {id: quote.id}
      expect(assigns(:quote)).to eq(quote)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Quote" do
        expect {
          post :create, params: {quote: valid_params}
        }.to change(Quote, :count).by(1)
      end
      it "assigns company and created_by" do
        post :create, params: {quote: valid_params}
        new_quote = assigns(:quote)
        expect(new_quote.company_id).to eq(company.id)
        expect(new_quote.created_by).to eq(current_user.id)
      end

      it "redirects to edit_informations" do
        post :create, params: {quote: valid_params}
        expect(response).to redirect_to(edit_informations_finances_quote_path(Quote.last.id))
      end
    end

    context "with invalid params" do
      it "does not create a new Quote" do
        expect {
          post :create, params: {quote: invalid_params}
        }.not_to change(Quote, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: {quote: invalid_params}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { {reference: "NEW-REF-123"} }

      it "updates the requested quote" do
        put :update, params: {id: quote.id, quote: new_attributes}
        quote.reload
        expect(quote.reference).to eq("NEW-REF-123")
      end

      it "redirects to edit_informations" do
        put :update, params: {id: quote.id, quote: valid_params}
        expect(response).to redirect_to(edit_informations_finances_quote_path(quote.id))
      end
    end

    context "with invalid params" do
      it "does not update the quote" do
        put :update, params: {id: quote.id, quote: invalid_params}
        expect(assigns(:quote).errors).to be_present
      end

      it "re-renders the 'edit' template" do
        put :update, params: {id: quote.id, quote: invalid_params}
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET #edit_informations" do
    it "assigns the requested quote as @quote" do
      get :edit_informations, params: {id: quote.id}
      expect(assigns(:quote)).to eq(quote)
    end
  end

  describe "PUT #update_informations" do
    let(:contact) { create(:contact, :with_client) }

    let(:valid_information_params) do
      {
        quote: {
          client_id: client.id,
          "primary-contacts": [contact.id],
          address: "123 Main St, Paris, France"
        }
      }
    end

    context "with valid params" do
      it "updates the quote information" do
        put :update_informations, params: valid_information_params.merge(id: quote.id)
        expect(quote.reload.commercial_contacts.count).to eq(1)
      end

      it "creates an intervention when intervention_id is blank" do
        expect {
          put :update_informations, params: valid_information_params.merge(id: quote.id)
        }.to change(Intervention, :count).by(1)
      end

      it "redirects to edit_prestations with success flash" do
        put :update_informations, params: valid_information_params.merge(id: quote.id)
        expect(response).to redirect_to(edit_prestations_finances_quote_path(quote.id))
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid params" do
      it "redirects back with alert flash" do
        allow_any_instance_of(Quote).to receive(:update).and_raise(ActiveRecord::RecordInvalid.new(quote))
        put :update_informations, params: valid_information_params.merge(id: quote.id)
        expect(response).to redirect_to(edit_informations_finances_quote_path(quote.id))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #edit_prestations" do
    it "assigns the requested quote as @quote" do
      get :edit_prestations, params: {id: quote.id}
      expect(assigns(:quote)).to eq(quote)
    end
  end

  describe "PUT #update_prestations" do
    let(:valid_prestation_params) do
      {
        quote: {
          items_attributes: [
            {
              prestation_id: create(:prestation).id,
              unit_price: 100,
              quantity: 1,
              unit: "hour"
            }
          ]
        }
      }
    end

    context "with valid params" do
      it "updates the quote prestations" do
        put :update_prestations, params: valid_prestation_params.merge(id: quote.id)
        expect(quote.reload.items.count).to eq(3)
      end

      it "redirects to quotes index with success flash" do
        put :update_prestations, params: valid_prestation_params.merge(id: quote.id)
        expect(response).to redirect_to(finances_quotes_path)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid params" do
      it "redirects back with alert flash" do
        allow_any_instance_of(Quote).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(quote))
        put :update_prestations, params: valid_prestation_params.merge(id: quote.id)
        expect(response).to redirect_to(edit_prestations_finances_quote_path(quote.id))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #client_headings" do
    let(:client) { create(:client) }

    context "when client exists" do
      it "assigns client and headings" do
        create_list(:heading, 2, client: client)
        get :client_headings, params: {id: client.id}, format: :turbo_stream
        expect(assigns(:client)).to eq(client)
        expect(assigns(:headings)).to match_array(client.headings)
      end
    end
  end

  describe "GET #admin_details" do
    let(:admin) { create(:admin, company: company) }

    it "assigns the admin" do
      get :admin_details, params: {id: admin.id}, format: :turbo_stream
      expect(assigns(:admin)).to eq(admin)
    end

    context "with turbo_stream format" do
      it "responds with turbo_stream" do
        get :admin_details, params: {id: admin.id}, format: :turbo_stream
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "GET #preview" do
    it "renders the preview modal" do
      get :preview, params: {id: quote.id}, format: :turbo_stream
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("remote_modal")
    end
  end

  describe "GET #pdf" do
    it "generates a PDF" do
      get :pdf, params: {id: quote.id}, format: :pdf
      expect(response.media_type).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to include("Devis #{quote.reference}")
    end
  end

  describe "private methods" do
    describe "#set_quote" do
      it "assigns the quote" do
        controller.params = {id: quote.id}
        controller.send(:set_quote)
        expect(controller.instance_variable_get(:@quote)).to eq(quote)
      end
    end
  end
end
