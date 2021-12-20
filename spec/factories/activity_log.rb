FactoryBot.define do
  factory :activity_log do

    trait :with_business do
      business { create(:business) }
    end
  end
end
