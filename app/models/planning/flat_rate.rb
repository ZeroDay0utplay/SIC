class FlatRate < Planning
  has_many :schedules, foreign_key: "planning_id", dependent: :destroy
  has_many :agents, through: :schedules
end
