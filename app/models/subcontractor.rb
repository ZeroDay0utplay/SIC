class Subcontractor < ApplicationRecord
  include CompanyScoped

  has_many :agents, class_name: "SubcontractorAgent", dependent: :delete_all
  has_many :admins, class_name: "SubcontractorAdmin", dependent: :delete_all
  has_many :subcontractor_skills, dependent: :delete_all
  has_many :documents, as: :documentable, dependent: :delete_all

  belongs_to :company

  has_one_attached :logo

  validates :email, :manager, :company_name, presence: true

  # Define allowed Ransack attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[company_or_manager]
  end

  ransacker :company_or_manager, formatter: proc { |query|
    query.downcase
  } do |parent|
    Arel::Nodes::NamedFunction.new(
      "LOWER",
      [Arel::Nodes::InfixOperation.new(
        "||",
        parent.table[:company_name],
        Arel::Nodes::InfixOperation.new("||", Arel::Nodes.build_quoted(" "), parent.table[:manager])
      )]
    )
  end
end
