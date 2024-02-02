FactoryBot.define do
  factory :vehicle do
    association :customer, factory: :customer
    name { Faker::Beer.unique.brand  }
    color { Faker::Color.color_name }
    year { (1800..2020).to_a.sample }
    chassis_number { Faker::Alphanumeric.unique.alphanumeric(number: 5) }
    registered_at { rand(15.years.ago..Time.now) }
    odometer { rand(0..1_000_000) }
  end
end
