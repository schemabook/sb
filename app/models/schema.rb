class Schema < ApplicationRecord
  FORMATS = ["JSON Schema", "Avro", "CSV"]

  belongs_to :team
  belongs_to :service, optional: :true

  validates :name, presence: true, uniqueness: { scope: :service_id }
  validates :team_id, presence: true
end
