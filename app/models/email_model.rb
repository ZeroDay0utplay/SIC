class EmailModel < ApplicationRecord
  include CompanyScoped

  belongs_to :company, optional: true
  validates :subject, presence: true
  validates :body, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["subject", "body"]
  end
end
