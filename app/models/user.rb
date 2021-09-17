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
end
