# rubocop:disable Rails/ApplicationController
class PagesController < ActionController::Base
  include Pundit
  include CurrentCompany
  # https://github.com/thoughtbot/high_voltage/blob/master/README.md#override
  include HighVoltage::StaticPage
  include HasBreadcrumbs

  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate do
    redirect_to root_path
  end

  private

  def set_breadcrumbs
    add_breadcrumbs [
      [t('common.home'), root_path],
      [I18n.t("pages.#{params['id']}")]
    ]
  end
end
# rubocop:enable Rails/ApplicationController
