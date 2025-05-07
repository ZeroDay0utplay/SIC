class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true
  has_one_attached :file

  enum :document_type, %i[kbis insurance_civil_liability tax_certificates ursaf_certificate manager_identity regular_certificate identity_piece carte_btp other]

  enum :document_status, %i[pending accepted refused expired]
end
