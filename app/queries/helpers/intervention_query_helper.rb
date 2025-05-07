class InterventionQueryHelper
  def initialize(interventions: Intervention.current_company.all, query: nil)
    @interventions = interventions
    @query = "%#{query}%"
  end

  def search
    @interventions
      .joins("LEFT JOIN clients ON clients.id = interventions.client_id")
      .joins("LEFT JOIN addresses ON addresses.addressable_id = interventions.id AND addresses.addressable_type = 'Intervention'")
      .where(
        client_name.matches(Arel::Nodes.build_quoted(@query))
          .or(address_street.matches(Arel::Nodes.build_quoted(@query)))
          .or(address_city.matches(Arel::Nodes.build_quoted(@query)))
      )
  end

  protected

  def client_name
    Arel::Nodes::NamedFunction.new("UNACCENT", [Client.arel_table[:name]])
  end

  def address_street
    Arel::Nodes::NamedFunction.new("UNACCENT", [Address.arel_table[:street]])
  end

  def address_city
    Arel::Nodes::NamedFunction.new("UNACCENT", [Address.arel_table[:city]])
  end
end
