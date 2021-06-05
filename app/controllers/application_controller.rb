class ApplicationController < ActionController::Base
  include Pundit
  include CurrentCompany

  protect_from_forgery with: :null_session
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_additional_data_for_exception_notifier
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource_or_scope)
    # if only admin with no users, go to create users
    if current_user&.admin? && current_company&.users&.count == 1
      admin_users_path
    else
      stored_location_for(resource_or_scope) || super
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :name,
        :username,
        :phone,
        :dark_theme
      ]
    )
  end

  def user_not_authorized
    flash[:error] = I18n.t('controllers.user_not_authorized')
    redirect_to(request.referer || root_path)
  end

  private

  def log_additional_data_for_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: (current_user || 'undefined'),
      current_company: current_company
    }
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
end
