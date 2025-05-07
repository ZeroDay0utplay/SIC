require "rails_helper"

RSpec.describe EmailModel, type: :model do
  # Test validations
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }

  # Test ransackable_attributes method
  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(EmailModel.ransackable_attributes).to eq(["subject", "body"])
    end
  end
end
