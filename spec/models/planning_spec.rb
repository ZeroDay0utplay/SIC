require "rails_helper"

RSpec.describe Planning, type: :model do
  it { should belong_to(:admin).class_name("Admin").with_foreign_key("user_id") }
  it { should belong_to(:intervention) }
  it { should belong_to(:client) }
  it { should belong_to(:prestation) }

  it { should have_many(:planning_contacts) }
  it { should have_many(:contacts).through(:planning_contacts) }
  it { should have_many(:planning_materials) }
  it { should have_many(:planning_vehicles) }
  it { should have_many(:materials).through(:planning_materials) }
  it { should have_many(:vehicles).through(:planning_vehicles) }
  it { should have_many(:planning_report_photos) }
  it { should have_many(:planning_photos) }
end
