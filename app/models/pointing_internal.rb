class PointingInternal < ApplicationRecord
  belongs_to :planning_agent
  has_one :agent, through: :planning_agent
  has_one :schedule, through: :planning_agent
  has_one :planning, through: :schedule
  has_one :intervention, through: :planning
end
