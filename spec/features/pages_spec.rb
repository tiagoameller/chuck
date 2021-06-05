require 'rails_helper'

RSpec.feature 'Pages', type: :feature do
  describe 'existing pages' do
    context 'TOS' do
      scenario 'should be susccessful' do
        visit page_path(:tos)

        expect(page).to have_content 'Ámbito de aplicación'
      end
    end
    context 'privacy' do
      scenario 'should be susccessful' do
        visit page_path(:privacy)

        expect(page).to have_content 'Tipología de los datos'
      end
    end
    context 'cookies' do
      scenario 'should be susccessful' do
        visit page_path(:cookies)

        expect(page).to have_content '¿Qué es una cookie?'
      end
    end
  end

  describe 'not existing pages' do
    context 'fail' do
      scenario 'should be redirected to root_path' do
        visit page_path(:not_existing)

        expect(page).to have_current_path root_path
      end
    end
  end
end
