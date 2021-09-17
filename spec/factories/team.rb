FactoryBot.define do
  factory :team do
    sequence :name do |n|
      "team-#{n}"
    end
  end
end
