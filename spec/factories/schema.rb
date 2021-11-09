FactoryBot.define do
  factory :schema do
    sequence :name do |n|
      "schema-#{n}"
    end
  end
end
