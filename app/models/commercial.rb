class Commercial < ApplicationRecord
  include CompanyScoped

  belongs_to :admin, class_name: "Admin", foreign_key: "user_id"
  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :intervention, optional: true
  belongs_to :client
  belongs_to :heading, optional: true
  belongs_to :company

  has_one :address, as: :addressable, dependent: :destroy
  has_many :items, dependent: :destroy
  has_one :commercial_detail, dependent: :destroy
  has_one :payment_method, dependent: :destroy
  has_many :prestations, through: :items
  has_many :commercial_contacts, dependent: :destroy
  has_many :contacts, through: :commercial_contacts

  has_one_attached :photo

  enum :reduction_unit, [:currency, :percentage]

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :payment_method
  accepts_nested_attributes_for :commercial_detail
  accepts_nested_attributes_for :address
end
