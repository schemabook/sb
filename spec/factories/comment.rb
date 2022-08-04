FactoryBot.define do
  factory :comment do
    body { "lorem ipsum dolor" }

    trait :with_user do
      user { create(:user) }
    end

    trait :with_schema do
      schema { create(:schema, :with_team, :with_format_and_body) }
    end
  end
end
