require "rails_helper"

RSpec.describe Skill, type: :model do
  it { should have_many(:user_skills) }
  it { should have_many(:users).through(:user_skills) }

  it { should validate_presence_of(:name) }

  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(Skill.ransackable_attributes).to eq(["combined_search"])
    end
  end

  describe "ransacker" do
    it "defines combined_search ransacker" do
      expect(Skill.ransackable_attributes).to include("combined_search")
    end
  end
end
