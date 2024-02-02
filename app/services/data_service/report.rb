class DataService::Report < ApplicationService
  def perform
    report = odometer_averages
    total_report = nationality_totals

    total_report.each do |nationality_id, total_customers|
      report[nationality_id][:total_customers] = total_customers
    end

    Nationality.find_each do |nationality|
      report[nationality.id][:nationality] = nationality.name
    end

    report
  end

  protected

  def odometer_averages
    query = Customer.joins(:vehicles)
                    .group(:nationality_id)
                    .select('nationality_id, avg(vehicles.odometer) as average')
    query.map do |result|
      [result.nationality_id, { odometer_average: result.average.round(2) }]
    end.to_h
  end

  def nationality_totals
    Customer.group(:nationality_id).count
  end
end
