class MentionLegal < ApplicationRecord
  validates :name, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description"]
  end
end
