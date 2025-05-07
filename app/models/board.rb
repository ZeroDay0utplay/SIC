class Board < ApplicationRecord
  include CompanyScoped

  has_many :column_items, dependent: :destroy
  has_many :tasks, through: :column_items
  belongs_to :company, optional: true

end
