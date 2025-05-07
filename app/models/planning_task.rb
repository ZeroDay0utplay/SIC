class PlanningTask < ApplicationRecord
  belongs_to :prestation
  belongs_to :planning
  belongs_to :agent, class_name: "Agent", foreign_key: :user_id, optional: true
  has_many :planning_photos, as: :imageable, dependent: :destroy

  attr_accessor :week_start, :week_end, :week_1_start, :week_2_start, :selected_dates

  scope :unscheduled, -> { where(user_id: nil) }
  scope :scheduled, -> { where.not(user_id: nil) }
end
