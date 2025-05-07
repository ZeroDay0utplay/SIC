class Skill < ApplicationRecord
  include CompanyScoped

  has_many :user_skills
  has_many :users, through: :user_skills
  belongs_to :company

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[combined_search]
  end

  ransacker :combined_search do |parent|
    Arel::Nodes::SqlLiteral.new("name")
  end
end
