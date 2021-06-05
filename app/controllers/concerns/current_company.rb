module CurrentCompany
  extend ActiveSupport::Concern

  included do
    def current_company
      return nil unless user_signed_in?

      @current_company ||= current_user.company
    end
    helper_method :current_company
  end
end
