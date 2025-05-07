require "rails_helper"

RSpec.describe Subcontractor, type: :model do
  it { should have_many(:agents).class_name("SubcontractorAgent").dependent(:delete_all) }
  it { should have_many(:admins).class_name("SubcontractorAdmin").dependent(:delete_all) }
  it { should have_many(:subcontractor_skills) }
  it { should have_one_attached(:logo) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:manager) }
  it { should validate_presence_of(:company_name) }

  describe ".ransackable_attributes" do
    it "returns the correct attributes for ransack" do
      expect(Subcontractor.ransackable_attributes).to match_array(["company_or_manager"])
    end
  end
end
