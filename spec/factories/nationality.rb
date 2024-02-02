FactoryBot.define do
  factory :nationality do
    name { Faker::Nation.unique.nationality }
  end
end
