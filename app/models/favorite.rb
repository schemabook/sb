class Favorite < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::SchemaValidator

  belongs_to :user
  belongs_to :schema
end
