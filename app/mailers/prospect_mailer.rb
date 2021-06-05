class ProspectMailer < ApplicationMailer
  def prospect_beta_request(prospect)
    @email_title = 'Gracias por solicitar acceso a myapp.com'
    @prospect = prospect
    @recipient = prospect.email

    mail to: check_env_emails(prospect.email), bcc: 'tiago.ameller@gmail.com', subject: @email_title
  end
end
