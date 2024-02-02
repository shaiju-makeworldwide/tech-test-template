class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_validation :format_attributes

  protected

  def format_attributes(attributes = [])
    attributes.each do |attribute|
      send("#{attribute}=", send(attribute)&.strip&.downcase)
    end
  end
end
