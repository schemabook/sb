class Service < ApplicationRecord
  belongs_to :team

  validates :name, presence: true, uniqueness: { scope: :team_id }
end
