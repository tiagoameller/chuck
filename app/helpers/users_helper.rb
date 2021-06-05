module UsersHelper
  include ApplicationHelper

  def users_for_select
    options_for_select(
      [[I18n.t('common.all'), '', { class: active_class(true) }]] +
      User.of_company(current_company).visible.order('active desc, last_name, first_name').collect do |user|
        [user.name.sorted, user.id, { class: active_class(user.active?) }]
      end,
      ''
    )
  end

  def render_user(model)
    [].tap do |column|
      present(model) do |user|
        column << link_to(user.username, admin_user_path(user), remote: true, data: { id: user.id })
        column << user.full_name
        column << user.phone
        column << user.email
        column << user.role_i18n
        column << user.active.humanize
        column << link_to(
          edit_admin_user_path(user),
          remote: true,
          class: 'btn btn-warning btn-sm btn_edit'
        ) { coreui_icon_l(:pencil) }
        column << link_to(
          admin_user_path(user),
          method: :delete,
          remote: true,
          data: { confirm: I18n.t('common.are_you_sure'), disable_with: '...' },
          class: 'btn btn-danger btn-sm btn_delete'
        ) { coreui_icon_l(:trash) }
        column << {
          row_id: dom_id(user)
        }
      end
    end
  end
end
