require "rails_helper"

RSpec.describe SubcontractorSkill, type: :model do
  # Test associations
  it { should belong_to(:subcontractor) }
  it { should belong_to(:skill) }
end
