class SubcontractorAgent < SubcontractorUser
  has_many :planning_subcontractor_agents
  has_many :planning_subcontractors, through: :planning_subcontractor_agents

  has_many :documents, as: :documentable
end
