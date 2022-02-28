FactoryBot.define do
  factory :schema do
    sequence :name do |n|
      "schema-#{n}"
    end

    trait :with_team do
      team { create(:team, :with_business) }
    end

    trait :with_format_and_body do
      file_type { "json" }
      format    { create(:format, file_type: :json) }
      body      { '{"foo": {"bar": 1}}' }
    end
  end
end
