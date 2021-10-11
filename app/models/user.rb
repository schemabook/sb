class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :business
  belongs_to :team

  # businesses are created during registration at the same time as users
  accepts_nested_attributes_for :business

  validates :email, presence: true
  validates :business, presence: true
  validates :team, presence: true

  delegate :admin?, to: :team

  def display_name
    return email if first_name.blank?

    "#{first_name} #{last_name}"
  end

  def display_name_with_email
    str = ""
    str += "#{first_name} " if first_name
    str += "#{last_name} " if last_name
    str += "(#{email})" if first_name
    str += "#{email}" unless first_name

    str
  end
end
