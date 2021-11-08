class Schema < ApplicationRecord
  FORMATS = ["JSON Schema", "Avro", "CSV"]

  belongs_to :team

  validates :name, presence: true
  validates :name, uniqueness: true # TODO: scope to business or area { scope: :business }
  validates :team_id, presence: true
end
