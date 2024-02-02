require 'rails_helper'

RSpec.describe 'Dashboard', type: :system do
  describe 'show' do
    it 'shows the right content' do
      visit root_path
      expect(page).to have_content('Beema Demo')
    end

    it 'shows the empty label when there are no customers' do
      visit root_path
      expect(page).to have_content('There are no customers yet.')
    end

    it 'shows all the existing customers' do
      FactoryBot.create_list(:vehicle, 3)
      visit root_path
      expect(page).not_to have_content('There are no customers yet.')
      Vehicle.includes(customer: :nationality).find_each do |vehicle|
        customer = vehicle.customer

        nationality = customer.nationality
        expect(page).to have_content(customer.name)
        expect(page).to have_content(nationality.name)
        expect(page).to have_content(customer.email)
        expect(page).to have_content(vehicle.name)
        expect(page).to have_content(vehicle.year)
        expect(page).to have_content(vehicle.chassis_number)
        expect(page).to have_content(vehicle.registered_at.strftime('%d/%m/%Y'))
        expect(page).to have_content(vehicle.odometer)
      end
    end
  end

  describe 'import' do
    it 'successfully uploads the csv file' do
      visit root_path
      file_path = Rails.root.join(*%w(spec fixtures database.csv))
      execute_script("el = document.getElementById('csv_file'); el.classList.remove('custom-file-input')")
      execute_script("document.getElementsByClassName('custom-file-label')[0].remove()")
      find('#csv_file').attach_file(file_path, make_visible: true)
      click_on 'Import data'
      expect(page).to have_content('The csv file was imported successfully.')
      expect(Vehicle.count).to eq(4)
      expect(Customer.count).to eq(3)
      expect(Nationality.count).to eq(2)
    end

    it 'shows an error when the csv file is invalid' do
      visit root_path
      file_path = Rails.root.join(*%w(spec fixtures invalid-database.csv))
      execute_script("el = document.getElementById('csv_file'); el.classList.remove('custom-file-input')")
      execute_script("document.getElementsByClassName('custom-file-label')[0].remove()")
      find('#csv_file').attach_file(file_path, make_visible: true)
      click_on 'Import data'
      expect(page).to have_content('The csv file had errors.')
      expect(Vehicle.count).to eq(0)
      expect(Customer.count).to eq(0)
      expect(Nationality.count).to eq(0)
    end
  end

  describe 'search' do
    it 'successfully filters the results' do
      FactoryBot.create_list(:vehicle, 3)
      Vehicle.first.update(name: 'aaa')
      Vehicle.second.update(name: 'bbb')
      Vehicle.third.update(name: 'ccc')

      Customer.first.update(name: 'ccc')
      Customer.second.update(name: 'bbb')
      Customer.third.update(name: 'aaa')

      visit root_path
      expect(page).to have_selector('table tbody tr', count: 3)
      fill_in 'query', with: 'aaa'
      click_on 'Search'
      expect(page).to have_selector('table tbody tr', count: 2)
    end
  end

  describe 'report' do
    it 'displays the button' do
      visit root_path
      href = '/report.csv'
      expect(page).to have_selector("a[href='#{href}']", text: 'Download report')
    end
  end
end
