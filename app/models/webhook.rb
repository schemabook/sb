class Webhook < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::UrlValidator

  belongs_to :user
  belongs_to :schema

  validates :url, presence: true, uniqueness: {scope: :schema_id}

  delegate :name, to: :schema, allow_nil: true

  # rubocop:disable Lint/UselessAssignment
  before_create do
    index = schema.webhooks.count + 1
  end
  # rubocop:enable Lint/UselessAssignment

  # TODO: decide if the version should be passed in
  def payload
    {
      url: schema.url,
      definition: JsonPresenter.new(schema, schema.versions.last).content
    }
  end
end
