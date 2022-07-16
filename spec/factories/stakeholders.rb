FactoryBot.define do
  factory :stakeholder do
    trait :with_user do
      user { create(:user) }
    end

    trait :with_schema do
      schema { create(:schema, :with_format_and_body, team: create(:team)) }
    end
  end
end
