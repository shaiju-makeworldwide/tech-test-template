require 'rails_helper'

RSpec.describe DataService::Report, type: :service do
  it 'generates the report' do
    nations = FactoryBot.create_list(:nationality, 2)
    group_a = FactoryBot.create_list(:customer, 3, nationality: nations[0])
    group_b = FactoryBot.create_list(:customer, 5, nationality: nations[1])
    [*group_a, *group_b].each do |customer|
      FactoryBot.create(:vehicle, customer: customer)
    end

    result = DataService::Report.new.perform
    expect(result.keys.sort).to eq(Nationality.pluck(:id).sort)

    result.each do |nationality_id, data|
      nationality = Nationality.find(nationality_id)
      customers = Customer.where(nationality_id: nationality_id)
      vehicles = Vehicle.where(customer: customers)
      odometer_average = vehicles.average(:odometer).round(2)

      expect(data[:nationality]).to eq(nationality.name)
      expect(data[:total_customers]).to eq(nationality.customers.count)
      expect(data[:odometer_average]).to eq(odometer_average)
    end
  end
end
