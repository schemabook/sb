class Stakeholder < ApplicationRecord
  validates :user_id, presence: true
  validates :schema_id, presence: true, uniqueness: { scope: :user_id }
end
