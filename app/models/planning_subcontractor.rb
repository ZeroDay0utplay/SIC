class PlanningSubcontractor < ApplicationRecord
  belongs_to :schedule
  belongs_to :subcontractor

  has_many :planning_subcontractor_agents
  has_many :subcontractor_agents, through: :planning_subcontractor_agents
end
