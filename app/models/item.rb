class Item < ApplicationRecord
  belongs_to :commercial
  belongs_to :prestation

  enum :reduction_unit, [:currency, :percentage]
end
