FactoryBot.define do
  factory :schema do
    sequence :name do |n|
      "schema-#{n}"
    end

    trait :with_team do
      team { create(:team, :with_business) }
    end

    trait :with_format do
      format { create(:format, file_type: :json) }
    end
  end
end
