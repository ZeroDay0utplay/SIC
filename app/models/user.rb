class User < ApplicationRecord
  include CompanyScoped

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :user_skills, dependent: :delete_all
  has_many :skills, through: :user_skills
  has_many :absences
  has_one_attached :photo

  belongs_to :company, optional: true

  enum :role, [:supervisor, :agent, :punctual, :regular, :finishing, :extern, :admin, :subcontractor, :superadmin]
  enum :platform, [:web, :mobile]

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "job", "email", "full_name", "role", "skills", "active"]
  end

  def generate_authentication_token
    self.authentication_token = SecureRandom.hex(10)
  end
end
