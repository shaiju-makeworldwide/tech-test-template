class Customer < ApplicationRecord
  validates :name, length: 3..50
  validates :email, length: 3..50, uniqueness: { case_sensitive: false }

  belongs_to :nationality
  has_many :vehicles, dependent: :destroy

  def self.search_by(query)
    return order(:id) if query.blank?

    params = ["%#{query.strip}%"] * 2
    joins(:vehicles)
      .where('customers.name LIKE ? OR vehicles.name LIKE ?', *params)
  end

  protected

  def format_attributes
    super(['email'])
  end
end
