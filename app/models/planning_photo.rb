class PlanningPhoto < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_one_attached :photo

  has_one :reverse_linked_photo, class_name: "PlanningPhoto", foreign_key: :linked_photo_id

  enum :photo_type, %i[truck information observation]
  enum :before_after, %i[before after]

  def paired_photo
    before? ? reverse_linked_photo : linked_photo
  end
end
