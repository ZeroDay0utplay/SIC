require "rails_helper"

RSpec.describe PlanningTask, type: :model do
  it { should belong_to(:prestation) }
  it { should belong_to(:planning) }
end
