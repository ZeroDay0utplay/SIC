class PlanningReportPhoto < ApplicationRecord
  belongs_to :planning
  has_one_attached :photo
  belongs_to :parent, class_name: "PlanningReportPhoto", optional: true
  has_one :child, class_name: "PlanningReportPhoto", foreign_key: "parent_id"

  enum :position, %i[before after]
end
