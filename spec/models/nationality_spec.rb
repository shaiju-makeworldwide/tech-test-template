require 'rails_helper'

RSpec.describe Nationality, type: :model do
  subject { FactoryBot.create(:nationality) }

  describe '#validations' do
    it { is_expected.to be_valid }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it 'strips and downcases the name before saving' do
      name = '  RoManiaN    '
      subject = FactoryBot.build(:nationality, name: name)
      subject.save
      expect(subject.reload.name).to eq(name.strip.downcase)
    end
  end

  describe '#associations' do
    it { is_expected.to have_many(:customers) }
  end
end
