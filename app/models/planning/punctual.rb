class Punctual < Planning
  has_one :schedule, foreign_key: "planning_id", dependent: :destroy
  has_many :agents, through: :schedule

  def self.ransackable_associations(auth_object = nil)
    ["client", "prestation"]
  end

  def self.ransackable_attributes(auth_object = nil)
    [""]
  end

  def self.search(query)
    return all if query.blank?

    joins(:prestation, :client, intervention: :address)
      .ransack(
        g: [
          {client_name_cont: query},
          {prestation_name_cont: query},
          {"addresses.city_cont" => query},
          {"addresses.street_cont" => query}
        ],
        m: "or"
      ).result
  end
end
