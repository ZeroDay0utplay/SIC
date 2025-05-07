require "rails_helper"

RSpec.describe UserSkill, type: :model do
  # Test associations
  it { should belong_to(:user) }
  it { should belong_to(:skill) }
end
