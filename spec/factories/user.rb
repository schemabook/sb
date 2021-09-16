FactoryBot.define do
  factory :user do
    email    { "admin@example.com" }
    password { "password" }

    business { association :business }
    team     { association :team, business: business }

    after(:create) { |object| object.business.update_column(:created_by, object.id) }
  end
end
