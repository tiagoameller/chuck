require 'rails_helper'

RSpec.describe CustomDeviseMailer, type: :mailer do
  let(:company) { Company.first }
  let(:user) { company.users.first }
  describe 'reset password' do
    let(:mail) do
      CustomDeviseMailer.reset_password_instructions(user, 'faketoken', {})
    end
    it 'generates a reset password email' do
      expect(mail.subject).to eq I18n.t('devise.mailer.reset_password_instructions.subject')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['info@sistemasc.net'])
    end
  end
end
