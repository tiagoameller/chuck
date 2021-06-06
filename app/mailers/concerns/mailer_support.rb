module MailerSupport
  extend ActiveSupport::Concern

  module ClassMethods
  end

  included do
    default from: 'Chuck Noriis <tiago.ameller@gmail.com>'
    layout 'mailer'
    helper ApplicationHelper

    before_action :load_inline_images

    def admin_emails
      User.super_admin.pluck(:email)
    end

    def admin_emails_plus_this_list(emails)
      if emails&.any?
        admin_emails + emails.delete_if(&:nil?)
      else
        admin_emails
      end
    end

    def check_env_emails(to_list)
      if Rails.env.development?
        logger.info "<*\\/*>Original email list for #{self.class.name}: #{to_list}"
        ['tiago.ameller@gmail.com']
      else
        to_list
      end
    end

    private

    def load_inline_images
      attachments.inline['logo_46_black_text.png'] =
        File.read(Rails.root.join('app', 'assets', 'images', 'application', 'logo_46_black_text.png').to_s)
    end
  end
end
