class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :schema

  validates :body, presence: true
end
