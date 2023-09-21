class User < ApplicationRecord
  include PublicIdGenerator

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :business
  belongs_to :team

  has_one_attached :avatar
  has_many :favorites

  # businesses are created during registration at the same time as users
  accepts_nested_attributes_for :business

  validates :email, presence: true

  delegate :admin?, to: :team

  before_create :generate_api_token

  def display_name
    return email if first_name.blank?

    "#{first_name} #{last_name}"
  end
  alias name display_name

  def display_name_with_email
    str = ""
    str += "#{first_name} " if first_name
    str += "#{last_name} " if last_name
    str += "(#{email})" if first_name
    str += "#{email}" unless first_name

    str
  end

  def generate_api_token
    self.api_token = generate_public_id
  end
end
