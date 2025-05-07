class PlanningContact < ApplicationRecord
  belongs_to :planning
  belongs_to :contact

  enum :contact_type, %w[primary secondary]
end
