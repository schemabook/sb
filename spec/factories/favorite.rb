FactoryBot.define do
  factory :favorite do
    trait :with_schema do
      schema { create(:schema, :with_team, :with_format_and_body) }
    end
  end
end
