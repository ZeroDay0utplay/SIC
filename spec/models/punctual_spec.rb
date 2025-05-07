require "rails_helper"

RSpec.describe Punctual, type: :model do
  it { should have_one(:schedule) }
  it { should have_many(:agents).through(:schedule) }
end
