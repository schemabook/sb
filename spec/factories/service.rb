FactoryBot.define do
  factory :service do
    sequence :name do |n|
      "service-#{n}"
    end

    trait :with_team do
      team { create(:team, :with_business) }
    end
  end
end
