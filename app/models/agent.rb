class Agent < User
  has_many :planning_agents, foreign_key: :agent_id
  has_many :schedules, through: :planning_agents

  def agent?
    true
  end

  def set_skills
    return "" if skills.blank?

    skills.pluck(:name).map { |skill| "<span>#{ERB::Util.html_escape(skill)}</span>" }.join
  end

  def regular_assigned_date(regular_id)
    schedules.where(planning_id: regular_id)
  end
end
