class Quote < Commercial
  belongs_to :prestation, optional: true
  belongs_to :template, class_name: "Commercial", foreign_key: "template_id", optional: true

  attr_accessor :use_as_template

  enum :state, [:Pending, :Approved, :Refused]

  def self.ransackable_attributes(auth_object = nil)
    ["client_name", "created_at", "combined_search"]
  end

  ransacker :combined_search, formatter: proc { |v| v } do |parent|
    Arel::Nodes::NamedFunction.new("concat_ws", [
      Arel::Nodes.build_quoted(" "),
      parent.table[:reference],
      parent.table[:state],
      parent.table[:created_at],
      Arel.sql("(SELECT clients.name FROM clients WHERE type = 'Quote' AND clients.id = commercials.client_id)"),
      Arel.sql("(SELECT prestations.name FROM prestations WHERE type = 'Quote' AND prestations.id = commercials.prestation_id)")
    ])
  end

  ransacker :client_name do
    Arel.sql("(SELECT clients.name FROM clients WHERE type = 'Quote' AND clients.id = commercials.client_id)")
  end

  def total_before_tax
    if items.first&.unit_price && items.first.quantity
      "€ #{items.first&.unit_price&.* items.first&.quantity}"
    end
  end

  scope :by_state, ->(state) { where(state: state) }
  scope :by_creation_dates, ->(creation_dates) { where("DATE(created_at) IN (?)", creation_dates) }
  scope :is_template, -> { where(is_template: true) }
  scope :is_not_template, -> { where(is_template: false) }

  def generate_reference
    prefix = Current.company.prefix_quote

    year_short = Date.today.strftime("%y")
    year_full = Date.today.strftime("%Y")
    month = Date.today.strftime("%m")

    dynamic_prefix = prefix
      .gsub("(AA)", year_short)
      .gsub("(aaaa)", year_full)
      .gsub("(annee)", year_full)
      .gsub("(mois)", month)

    last_reference = self.class
      .where("reference LIKE ?", "#{dynamic_prefix}%")
      .order(:reference)
      .pluck(:reference)
      .last

    if last_reference.present?
      last_order = last_reference.split("-").last.to_i
      next_order = last_order + 1
    else
      next_order = 1
    end

    "#{dynamic_prefix}#{format("%02d", next_order)}"
  end

  def first_step_valide?
    user_id&.present? && client_id&.present? && validate_date&.present? && signed_before&.present?
  end

  def second_step_valide?
    prestation_id&.present? && intervention&.present?
  end

  def last_step_valide?
    items&.any? && !items.pluck(:unit_price, :quantity).flatten.include?(nil)
  end

  def price_pretax
    items&.sum { |item| item.unit_price.to_f * item.quantity.to_f } || 0
  end

  def tax_price
    price_pretax * (Current.company.taux_tva || 0) / 100
  end

  def total_price
    price_pretax + tax_price
  end

  def global_reduction
    items&.pluck(:reduction)&.compact&.sum || 0
  end

  def price_after_reduction
    price_pretax - global_reduction
  end
end
