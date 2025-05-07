class Intervention < ApplicationRecord
  include CompanyScoped

  belongs_to :client
  belongs_to :company
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  belongs_to :heading, optional: true
  has_many :plannings, dependent: :destroy
  has_many :regulars, dependent: :destroy
  has_many :punctuals, dependent: :destroy
  has_many :flat_rates, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy

  def formatted_address
    return "" unless address.present?

    parts = [
      address.street,
      "#{address.postal_code} #{address.city}".presence,
      address.country
    ].compact

    parts.join("<br>").html_safe
  end

  def author
    if admin.present?
      admin&.full_name.to_s
    else
      ""
    end
  end

  class << self
    def search(query)
      if query.present?
        InterventionQueryHelper.new(interventions: self, query: query).search
      else
        all
      end
    end
  end
end
