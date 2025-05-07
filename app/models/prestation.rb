class Prestation < ApplicationRecord
  include CompanyScoped

  has_one_attached :photo
  belongs_to :company
  has_one_attached :photo

  validates :unity, presence: true
  validates :name, presence: true, uniqueness: {scope: :company_id}
  auto_strip_attributes :name, :description, :remark, :price, squish: true
  enum :type_prestation, [:service, :rent, :sell, :recurring, :flat_rate]
  enum :state, [:under_repair, :free]

  def self.ransackable_attributes(auth_object = nil)
    %w[name description]
  end

  def self.unities
    (%w[Jour Pièce Agent Forfait Camion] + Prestation.distinct.pluck(:unity)).uniq
  end
end
