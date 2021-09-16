class Business < ApplicationRecord
  has_many :users
  has_many :teams

  validates :name, presence: true
  validates :name, uniqueness: true

  def to_s
    name
  end
end
