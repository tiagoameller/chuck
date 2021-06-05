require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  let(:company) { Company.first }

  context 'login' do
    before(:each) do
      visit root_path
    end
    scenario 'susccessful login with email' do
      within('form') do
        fill_in 'user_login', with: 'tiago@sistemasc.net'
        fill_in 'user_password', with: '123456'
      end
      click_button 'commit'
      expect(page).to have_content company.full_name
    end
    scenario 'susccessful login with nickname' do
      within('form') do
        fill_in 'user_login', with: 'menzer.tiagoa'
        fill_in 'user_password', with: '123456'
      end
      click_button 'commit'
      expect(page).to have_content company.full_name
    end
    scenario 'unsusccessful login' do
      within('form') do
        fill_in 'user_login', with: 'menzer.tiagoa'
        fill_in 'user_password', with: 'bad password'
      end
      click_button 'commit'
      expect(page).to have_current_path new_user_session_path
    end
  end

  context 'forgot password' do
    before(:each) do
      visit root_path
    end
    scenario 'valid email' do
      click_link '', href: new_user_password_path
      expect(page).to have_current_path new_user_password_path

      # TODO: when fixed forgot password action
      # within('form') do
      #   fill_in 'user_email', with: 'tiago@sistemasc.net'
      # end
      # click_button 'commit'
      # ... expect(page).to have_content company.full_name
    end
  end
end
