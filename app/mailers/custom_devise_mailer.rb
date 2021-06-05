class CustomDeviseMailer < Devise::Mailer
  include MailerSupport

  def reset_password_instructions(resource, token, options)
    # TODO: translate
    @email_title = "Hola, #{resource.email}"
    @email_subtitle = 'Nos dicen que has olvidado tu contraseña'
    super(check_resource_email_env(resource), token, options)
  end

  private

  def check_resource_email_env(resource)
    clean_list = check_env_emails(resource.email)
    clean_list = clean_list.first if clean_list.is_a? Array
    resource.email = clean_list
    resource
  end
end
