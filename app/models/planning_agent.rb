class PlanningAgent < ApplicationRecord
  belongs_to :schedule
  belongs_to :agent, class_name: "User"
end
