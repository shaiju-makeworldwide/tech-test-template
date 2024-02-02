class Nationality < ApplicationRecord
  validates :name, length: 3..50, uniqueness: { case_sensitive: false }

  has_many :customers, dependent: :destroy

  protected

  def format_attributes
    super(['name'])
  end
end
