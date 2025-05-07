class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  def self.ransackable_attributes(auth_object = nil)
    ["street", "city", "postal_code"]
  end

  def formatted_address
    "#{street}, #{postal_code} #{city}, #{country}"
  end
end
