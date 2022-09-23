class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :version

  validates :body, presence: true
end
