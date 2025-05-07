class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :admins, dependent: :destroy
  has_many :agents, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :prestations, dependent: :destroy
  has_many :interventions, dependent: :destroy
  has_many :email_models, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :bills, dependent: :destroy

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  has_one_attached :logo

  def full_address
    ""
  end
end
