class Planning < ApplicationRecord
  include CompanyScoped

  has_many :planning_contacts, dependent: :destroy
  has_many :contacts, through: :planning_contacts

  has_many :planning_materials, dependent: :destroy
  has_many :planning_vehicles, dependent: :destroy
  has_many :materials, through: :planning_materials
  has_many :vehicles, through: :planning_vehicles
  has_many :planning_report_photos
  has_many :planning_photos, dependent: :destroy
  has_many :planning_photos, as: :imageable, dependent: :destroy
  has_many :tasks, class_name:"PlanningTask", foreign_key: "planning_id", dependent: :destroy

  belongs_to :client
  belongs_to :company
  belongs_to :prestation
  belongs_to :intervention
  belongs_to :bill, optional: true
  belongs_to :quote, optional: true
  belongs_to :admin, class_name: "Admin", foreign_key: "user_id"

  accepts_nested_attributes_for :tasks, allow_destroy: true

  def photo_pairs
    before_photos = planning_photos.before.includes(:reverse_linked_photo)
    before_photos.map do |before|
      [before, before.reverse_linked_photo]
    end
  end
end
