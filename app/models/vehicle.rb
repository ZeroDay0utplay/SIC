class Vehicle < ApplicationRecord
  has_many :documents, as: :documentable
end
