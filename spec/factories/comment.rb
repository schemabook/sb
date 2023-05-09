FactoryBot.define do
  factory :comment do
    body { "lorem ipsum dolor" }

    trait :with_user do
      user { create(:user) }
    end

    trait :with_version do
      version { create(:version, :with_schema) }
    end

    trait :with_user_and_version do
      version { create(:version, :with_schema) }
      user { create(:user, business: version.schema.team.business) }
    end
  end
end
