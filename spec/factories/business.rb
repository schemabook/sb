FactoryBot.define do
  factory :business do
    sequence(:name) { |n| "business-#{n}" }

    trait :with_activity_log do
      after(:create) do |business|
        create(:activity_log, business:)
      end
    end
  end
end
