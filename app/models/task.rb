class Task < ApplicationRecord
  belongs_to :column_item
  has_one :board, through: :column_item
  belongs_to :user

  has_many_attached :photos
end
