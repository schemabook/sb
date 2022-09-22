FactoryBot.define do
  factory :version do
    trait :with_schema do
      schema { create(:schema, :with_team, :with_format) }
    end
  end
end
