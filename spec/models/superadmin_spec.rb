require "rails_helper"

RSpec.describe Superadmin, type: :model do
  # Test inheritance
  it "inherits from User" do
    expect(Superadmin).to be < User
  end

  # Test the superadmin? method
  describe "#superadmin?" do
    it "returns true" do
      superadmin = Superadmin.new
      expect(superadmin.superadmin?).to be true
    end
  end
end
