require "rails_helper"

RSpec.describe ClientContact, type: :model do
  # Test associations
  it { should belong_to(:client) }
  it { should belong_to(:contact) }
end
