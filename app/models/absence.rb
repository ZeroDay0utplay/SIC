class Absence < ApplicationRecord
  belongs_to :user

  enum :type_absence, [:sick_day, :personal_reason, :rest, :vacation]
  enum :state, [:pending, :allowed, :refused]

  has_one_attached :logo

  validates :date_start, :date_end, presence: true

  default_scope { joins(:user) }

  def self.ransackable_attributes(auth_object = nil)
    %w[user_name combined_search]
  end

  ransacker :combined_search, formatter: proc { |v| v } do |parent|
    Arel::Nodes::NamedFunction.new("concat_ws", [
      Arel::Nodes.build_quoted(" "),
      User.arel_table[:first_name],
      User.arel_table[:last_name]
    ])
  end

  ransacker :user_name, formatter: proc { |v| v.downcase } do |parent|
    user_table = Arel::Table.new("users")

    parent.table[:user_id].eq(user_table[:id]).and(
      Arel::Nodes::NamedFunction.new("LOWER", [user_table[:first_name]])
    )
  end
end
