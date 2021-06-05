module CompaniesHelper
  include ApplicationHelper

  def render_company(model)
    [].tap do |column|
      present(model) do |company|
        column << link_to(company.name, admin_company_path(company), data: { id: company.id })
        column << company.nick
        column << company.vat_number
        column << mail_to(company.email)
        column << format_date(company.created_at)
        column << company.active.humanize
        column << link_to(edit_admin_company_path(company), class: 'btn btn-warning btn-sm btn_edit') { coreui_icon_l(:pencil) }
        column << link_to(
          admin_company_path(company),
          method: :delete,
          data: { confirm: I18n.t('common.are_you_sure'), disable_with: '...' },
          class: 'btn btn-danger btn-sm btn_delete'
        ) { coreui_icon_l(:trash) }
        column << {
          row_id: dom_id(company)
        }
      end
    end
  end
end
