class Stakeholder < ApplicationRecord
  belongs_to :user
  belongs_to :schema

  validates :schema_id, uniqueness: { scope: :user_id }

  delegate :display_name, to: :user
end
