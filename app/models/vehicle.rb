class Vehicle < ApplicationRecord
  belongs_to :customer

  validates :name, length: 3..50
  validates :color, length: 3..20
  validates :chassis_number, length: 3..10,
                             uniqueness: { case_sensitive: false }
  validates :year, inclusion: 1800..2020
  validates :registered_at, presence: true
  validates :odometer, numericality: { only_integer: true, greater_than: 0 }

  protected

  def format_attributes
    super(['chassis_number'])
  end
end
