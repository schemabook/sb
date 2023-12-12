class Service < ApplicationRecord
  include PublicIdGenerator

  UNPAID_LIMIT = 10

  belongs_to :team
  has_many :schemas

  validates :name, presence: true, uniqueness: {scope: :team_id}
  validates :created_by, presence: true

  delegate :name, to: :team, prefix: true

  def creator
    User.find created_by
  end
end
