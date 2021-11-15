class Service < ApplicationRecord
  belongs_to :team
  has_many :schemas

  validates :name, presence: true, uniqueness: { scope: :team_id }
  validates :created_by, presence: true

  def creator
    User.find created_by
  end
end
