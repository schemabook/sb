FactoryBot.define do
  factory :team do
    sequence :name do |n|
      "team-#{n}"
    end

    trait :with_business do
      business { create(:business) }
    end
  end
end
