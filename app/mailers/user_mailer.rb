class UserMailer < ApplicationMailer
  def answers(question, email)
    @question = question
    @email = email
    mail to: check_env_emails(@email), subject: I18n.t('emails.answers.subject')
  end
end
