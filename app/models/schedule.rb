class Schedule < ApplicationRecord
  belongs_to :punctual, class_name: "Punctual", foreign_key: "planning_id", optional: true
  belongs_to :regular, class_name: "Regular", foreign_key: "planning_id", optional: true
  belongs_to :flat_rate, class_name: "FlatRate", foreign_key: "planning_id", optional: true

  belongs_to :planning

  has_many :planning_agents, dependent: :destroy
  has_many :agents, through: :planning_agents

  has_many :planning_subcontractors
  has_many :subcontractors, through: :planning_subcontractors
  has_many :planning_subcontractor_agents, through: :planning_subcontractors
  has_many :subcontractor_agents, through: :planning_subcontractor_agents, source: :subcontractor_agent

  has_one :intervention, through: :planning
  has_one :prestation, through: :planning
end
