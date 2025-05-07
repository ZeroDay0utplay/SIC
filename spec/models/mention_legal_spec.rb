require "rails_helper"

RSpec.describe MentionLegal, type: :model do
  # Test validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  # Test ransackable_attributes method
  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(MentionLegal.ransackable_attributes).to eq(["name", "description"])
    end
  end
end
