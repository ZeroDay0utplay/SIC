class PlanningSubcontractorAgent < ApplicationRecord
  belongs_to :planning_subcontractor
  belongs_to :subcontractor_agent, class_name: "SubcontractorUser"

  has_one :planning, through: :planning_subcontractor
end
