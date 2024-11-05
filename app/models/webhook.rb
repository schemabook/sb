class Webhook < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::UrlValidator

  belongs_to :user
  belongs_to :schema

  validates :url, presence: true, uniqueness: {scope: :schema_id}

  delegate :name, to: :schema, allow_nil: true

  before_create do
    self.index = schema.webhooks.count + 1
  end

  # TODO: decide if the version should be passed in
  def payload()
    {
      url: self.schema.url,
      definition: JsonPresenter.new(self.schema, self.schema.versions.last).content,
    }
  end
end
