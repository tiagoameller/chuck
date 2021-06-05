module CurrentCompanyPublic
  extend ActiveSupport::Concern

  included do
    def current_company
      return nil if @user.blank?

      @current_company ||= @user&.company
    end
  end
end
