class CompanyMailer < ApplicationMailer
  # TODO: translate
  def company_signup(admin)
    @email_title = 'Gracias por registrar tu empresa en myapp.com'
    @admin = admin
    @company = @admin.company
    @recipient = @admin.email

    mail to: check_env_emails(@admin.email), bcc: User.super_admin.pluck(:email), subject: @email_title
  end
end
