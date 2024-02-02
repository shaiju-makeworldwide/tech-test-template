require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject { FactoryBot.create(:vehicle) }

  describe '#validations' do
    it { is_expected.to be_valid }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_length_of(:color).is_at_least(3) }
    it { should validate_length_of(:color).is_at_most(20) }
    it { should validate_length_of(:chassis_number).is_at_least(3) }
    it { should validate_length_of(:chassis_number).is_at_most(10) }
    it { should validate_uniqueness_of(:chassis_number).case_insensitive }
    it { should validate_inclusion_of(:year).in?(1800..2020) }
    it { should validate_presence_of(:registered_at) }
    it { should validate_numericality_of(:odometer).only_integer }

    it 'strips and downcases the chassis number before saving' do
      chassis_number = ' 3MbOLT '
      subject = FactoryBot.build(:vehicle, chassis_number: chassis_number)
      subject.save
      expect(subject.reload.chassis_number).to eq(chassis_number.strip.downcase)
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to(:customer) }
  end
end
