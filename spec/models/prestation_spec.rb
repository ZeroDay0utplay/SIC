require "rails_helper"

RSpec.describe Prestation, type: :model do
  it { should validate_presence_of(:unity) }

  it "strips whitespace from name, description, remark, and price" do
    prestation = Prestation.new(
      name: "  Service  ",
      description: "  A description  ",
      remark: "  A remark  ",
      price: "  100.00  ",
      unity: "some unit"
    )
    prestation.valid?
    expect(prestation.name).to eq("Service")
    expect(prestation.description).to eq("A description")
    expect(prestation.remark).to eq("A remark")
    expect(prestation.price).to eq(100.0)
  end

  it do
    should define_enum_for(:type_prestation)
      .with_values([:service, :rent, :sell, :recurring, :flat_rate])
  end

  it do
    should define_enum_for(:state)
      .with_values([:under_repair, :free])
  end

  describe "photo attachment" do
    it "can have an attached photo" do
      prestation = Prestation.new
      prestation.photo.attach(
        io: StringIO.new("dummy image content"),
        filename: "test_photo.png",
        content_type: "image/png"
      )

      expect(prestation.photo).to be_attached
    end
  end

  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(Prestation.ransackable_attributes).to eq(["name", "description"])
    end
  end
end
