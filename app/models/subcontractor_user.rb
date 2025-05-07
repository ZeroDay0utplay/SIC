class SubcontractorUser < ApplicationRecord
  belongs_to :subcontractor

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email]
  end
end
