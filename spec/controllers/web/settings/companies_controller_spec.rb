require "rails_helper"

RSpec.describe Web::Settings::CompaniesController, type: :controller do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }

  let(:valid_attributes) do
    {
      social_reason: "Valid Company",
      email: "company@example.com",
      tel: "123456789",
      address: "123 Main St",
      country: "Country",
      establishment: "2020-01-01",
      taux_tva: 20,
      iban: "GB29NWBK60161331926819",
      bic: "NWBKGB2L",
      prefix_bill: "INV",
      prefix_quote: "QUO",
      city: "City",
      postal_code: "12345",
      address2: "Address Line 2",
      footer_page: "Footer Text",
      logo: nil
    }
  end
  let(:invalid_attributes) do
    {
      social_reason: nil, # Invalid as social_reason is required
      email: "invalidemail",
      tel: nil,
      address: nil,
      country: nil
    }
  end

  before do
    sign_in admin
  end

  describe "private #set_company" do
    it "sets the @company instance variable" do
      controller.params = {id: company.id}
      controller.send(:set_company)
      expect(assigns(:company)).to eq(company)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: {id: company.id}
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the company and redirects to settings company path" do
        patch :update, params: {id: company.id, company: valid_attributes}
        expect(response).to redirect_to(settings_company_path)
        expect(flash[:success]).to eq("La société a été mise à jour avec succès.")
        company.reload
        expect(company.social_reason).to eq("Valid Company")
      end
    end

    context "with invalid attributes" do
      it "does not update the company and renders the Turbo Stream template for the edit form" do
        patch :update, params: {id: company.id, company: invalid_attributes}, format: :turbo_stream
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("edit-company")
      end
    end
  end

  describe "PATCH #update_bank" do
    context "with valid attributes" do
      it "updates the company and redirects to the bank settings page" do
        patch :update_bank, params: {id: company.id, company: valid_attributes}
        expect(response).to redirect_to(settings_company_path)
        company.reload
        expect(company.iban).to eq("GB29NWBK60161331926819")
      end
    end

    context "with invalid attributes" do
      it "does not update the company and renders the Turbo Stream template for the bank form" do
        patch :update_bank, params: {id: company.id, company: invalid_attributes}, format: :turbo_stream
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("edit-bank")
      end
    end
  end

  describe "PATCH #update_numberings" do
    context "with valid attributes" do
      it "updates the company and redirects to the numbering settings page" do
        patch :update_numberings, params: {id: company.id, company: valid_attributes}
        expect(response).to redirect_to(settings_company_path)
        company.reload
        expect(company.prefix_bill).to eq("INV")
        expect(company.prefix_quote).to eq("QUO")
      end
    end

    context "with invalid attributes" do
      it "does not update the company and renders the Turbo Stream template for the numbering form" do
        patch :update_numberings, params: {id: company.id, company: invalid_attributes}, format: :turbo_stream
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("edit-numbering")
      end
    end
  end
end
