require 'rails_helper'

RSpec.describe DataService::Import, type: :service do
  let(:rows) do
    [
      ['Josh','Gre','j@a.me','Foc','2018','12345','Blue','02/02/2010',30000],
      ['Billy','Bel','m@a.me','Foc','2018','12346','Blue','02/02/2010',30000],
      ['Sam','Rom','g@a.me','Foc','2018','12347','Blue','02/02/2010',30000],
      ['Sam','Rom','g@a.me','Foc','2018','12348','Blue','02/02/2010',30000],
      ['Sam','Rom','g@a.me','Foc','2018','12348','Blue','02/02/2010',30000]
    ]
  end

  it 'creates the nationality, customer and vehicle from the given row' do
    DataService.import(rows[0])

    expect(Nationality.count).to eq(1)
    expect(Customer.count).to eq(1)
    expect(Vehicle.count).to eq(1)

    nationality = Nationality.first
    expect(nationality.name).to eq(rows[0][1].strip.downcase)
    customer = Customer.first
    expect(customer.name).to eq(rows[0][0])
    expect(customer.email).to eq(rows[0][2].strip.downcase)
    vehicle = Vehicle.first
    expect(vehicle.name).to eq(rows[0][3])
    expect(vehicle.year).to eq(rows[0][4].to_i)
    expect(vehicle.chassis_number).to eq(rows[0][5].strip.downcase)
    expect(vehicle.color).to eq(rows[0][6])
    expect(vehicle.registered_at).to eq(rows[0][7].to_datetime)
    expect(vehicle.odometer).to eq(rows[0][8])
  end

  it 'ignores duplicates' do
    rows.each { |row| DataService.import(row) }
    expect(Nationality.count).to eq(3)
    expect(Customer.count).to eq(3)
    expect(Vehicle.count).to eq(4)
  end
end
