require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  # describe 'admin_emails' do
  #   it 'returns list of emails' do
  #     expect(ApplicationMailer.new.admin_emails).to be_a Array
  #   end
  # end

  # describe 'admin_emails_plus_this_list' do
  #   context 'with list' do
  #     it 'returns admin emails plus input' do
  #       expect(ApplicationMailer.new.admin_emails_plus_this_list(['sample@email.com'])).to include('sample@email.com')
  #     end
  #   end
  #   context 'empty input' do
  #     it 'returns admin emails' do
  #       expect(ApplicationMailer.new.admin_emails_plus_this_list([])).to eq ApplicationMailer.new.admin_emails
  #     end
  #   end
  #   context 'nil input' do
  #     it 'returns admin emails' do
  #       expect(ApplicationMailer.new.admin_emails_plus_this_list(nil)).to eq ApplicationMailer.new.admin_emails
  #     end
  #   end
  # end

  # describe 'check_env_emails' do
  #   context 'not in development' do
  #     it 'returns input list' do
  #       expect(ApplicationMailer.new.check_env_emails(['sample@email.com'])).to eq ['sample@email.com']
  #     end
  #   end
  # end
end
