FactoryBot.define do
  factory :user do
    email    { "admin@example.com" }
    password { "password" }

    factory :user_with_business do
      business { create(:business) }

      after(:create) do |user, evaluator|
        evaluator.business.update(created_by: user.id)
        evaluator.business.reload
      end
    end
  end
end
