require "rails_helper"

RSpec.describe Quote, type: :model do
  let(:company) { create(:company, prefix_quote: "Q(AA)-", taux_tva: 20) }
  let(:client) { create(:client) }
  let(:admin) { create(:admin, company: company) }
  let(:prestation) { create(:prestation) }
  let(:quote) { create(:quote, company: company, client: client, created_by: admin.id) }
  let(:item1) { build(:item, unit_price: 100, quantity: 2, reduction: 10, commercial: quote) }
  let(:item2) { build(:item, unit_price: 50, commercial: quote) }

  before do
    allow(Current).to receive(:company).and_return(company)
  end

  describe "associations" do
    it { is_expected.to belong_to(:prestation).optional }
  end
end
