require 'csv'

class VehiclesController < ApplicationController
  EXPECTED_HEADERS = %i[Name Nationality Email Model Year ChassisNumber Color
                        RegistrationDate OdometerReading].freeze
  REPORT_HEADERS = ['Nationality', 'Customers', 'Average Odometer'].freeze

  def index
    customers = Customer.search_by(params[:query]).select(:id)
    @vehicles = Vehicle.where(customer_id: customers)
                       .includes(customer: :nationality)
  end

  def search
    redirect_to root_path(query: params[:query])
  end

  def import
    process_csv_file

    flash[:success] = 'The csv file was imported successfully.'
  rescue ArgumentError
    flash[:danger] = 'The csv file had errors.'
  ensure
    redirect_to root_path
  end

  def report
    filename = "report-#{Time.zone.today}.csv"
    send_data generate_report,
              type: 'application/csv; header=present',
              disposition: "attachment; filename=#{filename}.csv"
  end

  protected

  def process_csv_file
    raise ArgumentError if params[:csv_file].blank?

    # TODO: Bulk import to improve the performance
    CSV.foreach(params[:csv_file].path).each_with_index do |row, index|
      if index.zero?
        raise ArgumentError if row.compact.map(&:to_sym) != EXPECTED_HEADERS

        next
      end
      DataService.import(row)
    end
  end

  def generate_report
    # TODO: Start responding with csv data while it's generated to avoid
    # blocking the request until the entire file is generated
    CSV.generate(headers: true) do |csv|
      csv << REPORT_HEADERS

      DataService.report.each_value do |data|
        csv << [data[:nationality], data[:total_customers],
                data[:odometer_average]]
      end
    end
  end
end
