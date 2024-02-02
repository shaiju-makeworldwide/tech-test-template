require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { FactoryBot.create(:customer) }

  describe '#validations' do
    it { is_expected.to be_valid }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email).is_at_least(3) }
    it { should validate_length_of(:email).is_at_most(50) }

    it 'strips and downcases the email before saving' do
      email = '  aaa@BBB.cCc    '
      subject = FactoryBot.build(:customer, email: email)
      subject.save
      expect(subject.reload.email).to eq(email.strip.downcase)
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to(:nationality) }
    it { is_expected.to have_many(:vehicles) }
  end

  describe '#search_by' do
    it 'returns all customers when the query is blank' do
      FactoryBot.create_list(:vehicle, 3)
      subject = Customer
      expect(Customer.count).to eq(3)
      expect(subject.search_by('   ').count).to eq(3)
      expect(subject.search_by(nil).count).to eq(3)
    end

    it 'filters the customers by their name or their vehicle name' do
      FactoryBot.create_list(:vehicle, 3)
      Vehicle.first.update(name: 'aaa')
      Vehicle.second.update(name: 'bbb')
      Vehicle.third.update(name: 'ccc')

      Customer.first.update(name: 'ccc')
      Customer.second.update(name: 'bbb')
      Customer.third.update(name: 'aaa')

      subject = Customer
      expect(Customer.count).to eq(3)
      expect(subject.search_by(' aaa ').count).to eq(2)
    end
  end
end
