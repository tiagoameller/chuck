class UsersDatatable < ApplicationDatatable
  private

  def count
    User.visible_users(current_company).count
  end

  def data
    users.map { |model| @view.render_user(model) }
  end

  def total_entries
    users.total_count
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    search_value = params[:search][:value] if params.key? :search
    users = User.visible_users(current_company).page(page).per(per_page).order("#{sort_column} #{sort_direction}")
    if search_value.blank?
      users
    else
      search_string = []
      columns.each { |term| search_string << "cast(#{term} as varchar) ilike :search" }
      users.where(search_string.join(' or '), search: "%#{search_value}%")
    end
  end

  def columns
    %w(loginname first_name email role active last_name name)
  end
end
