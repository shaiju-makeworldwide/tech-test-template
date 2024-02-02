class DataService::Import < ApplicationService
  attr_accessor :raw_nationality, :raw_customer, :raw_vehicle, :nationality,
                :customer

  def initialize(row)
    self.raw_nationality = { name: row[1]&.strip&.downcase }
    self.raw_customer = { name: row[0], email: row[2]&.strip&.downcase }
    self.raw_vehicle = { name: row[3], year: row[4],
                         chassis_number: row[5]&.strip&.downcase,
                         color: row[6], registered_at: row[7],
                         odometer: row[8] }
  end

  def perform
    ensure_nationality
    ensure_customer
    ensure_vehicle
  end

  protected

  def ensure_nationality
    name = raw_nationality[:name]
    self.nationality = Nationality.find_or_create_by(name: name)
  end

  def ensure_customer
    self.customer = Customer.find_by(email: raw_customer[:email])
    return if customer

    self.customer = nationality.customers.create(raw_customer)
  end

  def ensure_vehicle
    return if Vehicle.find_by(chassis_number: raw_vehicle[:chassis_number])

    customer.vehicles.create(raw_vehicle)
  end
end
