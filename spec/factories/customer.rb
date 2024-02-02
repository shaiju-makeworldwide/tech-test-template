FactoryBot.define do
  factory :customer do
    association :nationality, factory: :nationality
    name { Faker::Name.name  }
    email { Faker::Internet.unique.email }
  end
end
