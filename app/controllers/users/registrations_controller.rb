module Users
  class RegistrationsController < Devise::RegistrationsController
    include HasBreadcrumbs

    private

    def set_breadcrumbs
      add_breadcrumbs [
        [t('common.home'), root_path],
        [User.model_name.human(count: :many), admin_users_path],
        [I18n.t('common.profile')]
      ]
    end
  end
end
