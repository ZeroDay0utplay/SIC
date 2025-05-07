require "rails_helper"

RSpec.describe Contact, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:client_contacts) }
  end

  describe ".ransackable_attributes" do
    it "returns the correct list of ransackable attributes" do
      expect(Contact.ransackable_attributes).to match_array(["combined_search"])
    end
  end
end
