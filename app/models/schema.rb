class Schema < ApplicationRecord
  belongs_to :team
  belongs_to :service, optional: true
  belongs_to :format

  validates :name, presence: true, uniqueness: { scope: :service_id }
  validates :team_id, presence: true
  validates :format_id, presence: true
end
