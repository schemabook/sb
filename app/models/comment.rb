class Comment < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::CommentValidator

  belongs_to :user
  belongs_to :version

  validates :body, presence: true
end
