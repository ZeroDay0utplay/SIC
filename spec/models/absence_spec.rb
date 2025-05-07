require "rails_helper"

RSpec.describe Absence, type: :model do
  let(:user) { create(:user) }
  let(:absence) { build(:absence, user: user) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_one_attached(:logo) }
  end

  describe "Enums" do
    it { should define_enum_for(:type_absence).with_values(sick_day: 0, personal_reason: 1, rest: 2, vacation: 3) }
    it { should define_enum_for(:state).with_values(pending: 0, allowed: 1, refused: 2) }
  end

  describe "Validations" do
    it { should validate_presence_of(:date_start) }
    it { should validate_presence_of(:date_end) }
  end

  describe "Ransackable Attributes" do
    it "returns the correct ransackable attributes" do
      expect(Absence.ransackable_attributes).to match_array(%w[user_name combined_search])
    end
  end

  describe "Ransackers" do
    describe "#combined_search" do
      it "concatenates the user's first and last name" do
        user = create(:user, first_name: "John", last_name: "Doe")
        absence = create(:absence, user: user)
        result = Absence.ransack(combined_search_cont: "John Doe", m: "or").result
        expect(result).to include(absence)
      end
    end

    describe "#user_name" do
      it "finds absences by user's first name (case insensitive)" do
        user = create(:user, first_name: "John")
        absence = create(:absence, user: user)
        result = Absence.ransack(user_name_cont: "john", m: "or").result
        expect(result).to include(absence)
      end
    end
  end
end
