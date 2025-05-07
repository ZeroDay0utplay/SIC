class Regular < Planning
  has_many :schedules, foreign_key: "planning_id", dependent: :destroy
  has_many :agents, through: :schedules

  attr_accessor :agent_schedule_dates

  def formatted_address
    address = intervention.address
    "#{address.street} #{address.postal_code} #{address.city}"
  end

end
