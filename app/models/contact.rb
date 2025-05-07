class Contact < ApplicationRecord
  include CompanyScoped

  has_many :client_contacts, dependent: :destroy
  has_many :commercial_contacts, dependent: :destroy

  has_many :clients, through: :client_contacts
  belongs_to :company, optional: true

  enum :role, %i[prospect individual external internal]

  def self.ransackable_attributes(auth_object = nil)
    %w[combined_search]
  end

  ransacker :combined_search do |parent|
    parent.table[:first_name]
      .concat(Arel::Nodes.build_quoted(" "))
      .concat(parent.table[:last_name])
      .concat(Arel::Nodes.build_quoted(" "))
      .concat(parent.table[:email])
      .concat(Arel::Nodes.build_quoted(" "))
      .concat(parent.table[:phone])
      .concat(Arel::Nodes.build_quoted(" "))
      .concat(parent.table[:job])
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
