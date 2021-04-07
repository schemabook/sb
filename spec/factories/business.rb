FactoryBot.define do
  factory :business do
    sequence :name do |n|
      "business-#{n}"
    end
  end
end
