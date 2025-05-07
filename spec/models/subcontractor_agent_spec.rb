require "rails_helper"

RSpec.describe SubcontractorAgent, type: :model do
  # Test associations
  it { should belong_to(:subcontractor) }

  # Test validations
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  # Test instance methods
  describe "#full_name" do
    it "returns the full name of the agent" do
      agent = SubcontractorAgent.new(first_name: "John", last_name: "Doe")
      expect(agent.full_name).to eq("John Doe")
    end
  end

  # Test ransackable_attributes method
  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(SubcontractorAgent.ransackable_attributes).to eq(["first_name", "last_name", "email"])
    end
  end
end
