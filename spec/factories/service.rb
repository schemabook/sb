FactoryBot.define do
  factory :service do
    sequence :name do |n|
      "service-#{n}"
    end
  end
end
