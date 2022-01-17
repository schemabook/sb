FactoryBot.define do
  factory :user do
    email    { "admin@example.com" }
    password { "password" }

    business { association :business, :with_activity_log }
    team     { association :team, business: business }

    after(:create) do |object|
      object.business.update({ created_by: object.id })
    end

    trait :admin do
      team { association :team, name: Team::ADMIN_TEAM_NAME, business: business, administrators: true }
    end
  end
end
