require "rails_helper"

RSpec.describe Regular, type: :model do
  it { should have_many(:schedules) }
  it { should have_many(:agents).through(:schedules) }
end
