require 'rails_helper'

RSpec.feature 'Admin user', type: :feature do
  let(:company) { Company.first }
  let(:no_fields_document) { company.documents.create!(attributes_for(:document)) }
  let(:document) { company.documents.first }
  let(:user) { company.users.first }
  let(:admin_user) { company.users.admin.first }

  describe 'admin CRUD for users' do
    before do
      login_admin
    end
    after do
      logout_user
    end

    # I'm unable to get tested modal forms

    # context 'create new user' do
    #   scenario 'should be successful', js: true do
    #     visit admin_users_path
    #     find('#new_user_btn').click
    #     expect(page).to have_content('Nombre completo')
    #     within '#new_user' do
    #       fill_in 'user_email', with: 'valid@email.com'
    #       fill_in 'user_password', with: '123456'
    #       fill_in 'user_password_confirmation', with: '123456'
    #     end
    #     click_button 'commit'
    #     expect(page).to have_content 'valid@email.com'
    #     expect(page).to have_current_path admin_user_path(User.last)
    #   end

    #   scenario 'should fail', js: true do
    #     visit new_admin_user_path
    #     click_button 'commit'
    #     expect(page).to have_content 'revise los datos:'
    #   end
    # end

    # context 'update user' do
    #   scenario 'should be successful' do
    #     user = company.users.create!(attributes_for(:user, email: Faker::Internet.email))
    #     visit edit_admin_user_path(user)
    #     within('user_form') do
    #       fill_in 'user_name', with: 'Jane'
    #       fill_in 'user_email', with: 'jane.doe@example.com'
    #     end
    #     click_button 'commit'
    #     expect(page).to have_content 'jane.doe@example.com'
    #   end

    #   scenario 'should fail' do
    #     user = company.users.create!(attributes_for(:user, email: Faker::Internet.email))
    #     visit edit_admin_user_path(user)
    #     within('user_form') do
    #       fill_in 'user_name', with: ''
    #     end
    #     click_button 'commit'
    #     expect(page).to have_content 'revise los datos:'
    #   end
    # end

    context 'index', focus: true do
      scenario 'should be successful' do
        visit admin_users_path
        # expect(page.find_all('table>tbody>tr').count).to eq User.visible_users(company).count
        expect(page).to have_content User.model_name.human(count: :many)
      end
    end
  end
end
