class Favorite < ApplicationRecord
  validates :user_id, presence: true
  validates :schema_id, presence: true
end
