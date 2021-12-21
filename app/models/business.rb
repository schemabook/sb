class Business < ApplicationRecord
  has_many :users
  has_many :teams

  has_one :activity_log

  validates :name, presence: true
  validates :name, uniqueness: true

  def to_s
    name
  end
end
