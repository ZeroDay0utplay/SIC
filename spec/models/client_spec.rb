require "rails_helper"

RSpec.describe Client, type: :model do
  # Test associations
  it { should have_many(:client_contacts) }
  it { should have_many(:contacts).through(:client_contacts) }

  # Test enum
  it do
    should define_enum_for(:client_type)
      .with_values(["particular", "professional"])
  end

  # Test Active Storage attachment
  it "can have an attached logo" do
    client = Client.new
    client.logo.attach(
      io: StringIO.new("dummy image content"),
      filename: "test_logo.png",
      content_type: "image/png"
    )

    expect(client.logo).to be_attached
  end

  # Test ransackable_attributes method
  describe ".ransackable_attributes" do
    it "returns only ransackable attributes" do
      expect(Client.ransackable_attributes).to eq(["name", "email"])
    end
  end

  # Test attr_accessor fields
  describe "attr_accessor attributes" do
    it "allows reading and writing for :role" do
      client = Client.new
      client.role = 0
      expect(client.role).to eq("representative")
    end
  end
end
