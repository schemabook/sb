FactoryBot.define do
  factory :user do
    email    { "admin@example.com" }
    password { "password" }

    factory :user_with_business do
      business { "example" }
    end
  end
end
