class Client < ApplicationRecord
  include CompanyScoped

  has_one :address, as: :addressable, dependent: :destroy
  has_many :interventions
  has_many :client_contacts
  has_many :contacts, through: :client_contacts
  has_many :punctuals
  has_many :regulars
  has_many :flat_rates
  has_many :headings

  has_one_attached :logo

  belongs_to :company

  validates :name, presence: true
  validates :email, presence: true

  enum :client_type, [:particular, :professional]
  enum :role, [:representative, :contractor]

  accepts_nested_attributes_for :address, update_only: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "email"]
  end

  def formatted_address
    return "" if address.nil?

    "#{address.street.downcase}, #{address.postal_code}, #{address.city.downcase.camelcase}, #{address.country.camelcase}"
  end
end
