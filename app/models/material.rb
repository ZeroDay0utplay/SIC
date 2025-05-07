class Material < ApplicationRecord
  include CompanyScoped

  belongs_to :company
  has_many :documents, as: :documentable
end
