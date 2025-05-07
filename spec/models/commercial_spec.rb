require "rails_helper"

RSpec.describe Commercial, type: :model do
  # First Company DATA
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let(:user) { create(:user, company: company) }
  let(:client) { create(:client, company: company) }
  let(:commercial) { create(:commercial, company: company, admin: admin, created_by: user.id, client: client) }

  # Second Company DATA
  let(:second_company) { create(:company) }
  let(:second_admin) { create(:admin, company: second_company) }
  let(:second_user) { create(:user, company: second_company) }
  let(:second_client) { create(:client, company: second_company) }
  let(:second_commercial) { create(:commercial, company: second_company, admin: second_admin, created_by: second_user.id, client: second_client) }

  describe "associations" do
    it { is_expected.to belong_to(:admin).class_name("Admin").with_foreign_key("user_id") }
    it { is_expected.to belong_to(:creator).class_name("User").with_foreign_key("created_by") }
    it { is_expected.to belong_to(:intervention).optional }
    it { is_expected.to belong_to(:client) }
    it { is_expected.to belong_to(:heading).optional }
    it { is_expected.to belong_to(:company) }

    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:items).dependent(:destroy) }
    it { is_expected.to have_one(:commercial_detail).dependent(:destroy) }
    it { is_expected.to have_one(:payment_method).dependent(:destroy) }
    it { is_expected.to have_many(:prestations).through(:items) }
    it { is_expected.to have_many(:commercial_contacts).dependent(:destroy) }
    it { is_expected.to have_many(:contacts).through(:commercial_contacts) }

    it { is_expected.to have_one_attached(:photo) }

    it { is_expected.to accept_nested_attributes_for(:items).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:payment_method) }
    it { is_expected.to accept_nested_attributes_for(:commercial_detail) }
    it { is_expected.to accept_nested_attributes_for(:address) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:reduction_unit).with_values(currency: 0, percentage: 1) }
  end

  describe "scopes" do
    describe "company_scoped" do
      before { Current.company = company }
      it "only returns commercials for the current company" do
        expect(Commercial.all).to include(commercial)
        expect(Commercial.all).not_to include([second_commercial])
      end
    end
  end
end
