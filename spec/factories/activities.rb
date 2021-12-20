FactoryBot.define do
  factory :activity do
    title  { "title" }
    detail { "detail" }

    trait :with_user do
      user { create(:user) }
    end

    trait :with_activity_log do
      activity_log { create(:activity_log, :with_business) }
    end
  end
end
