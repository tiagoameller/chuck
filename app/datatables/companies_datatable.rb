class CompaniesDatatable < ApplicationDatatable
  private

  def count
    Company.all.count
  end

  def data
    companies.map { |model| @view.render_company(model) }
  end

  def total_entries
    companies.total_count
  end

  def companies
    @companies ||= fetch_companies
  end

  def fetch_companies
    search_value = params[:search][:value] if params.key? :search
    companies = Company.all.page(page).per(per_page).order("#{sort_column} #{sort_direction}")
    if search_value.blank?
      companies
    else
      search_string = []
      columns.each { |term| search_string << "cast(#{term} as varchar) ilike :search" }
      companies.where(search_string.join(' or '), search: "%#{search_value}%")
    end
  end

  def columns
    # second created_at is a placeholder
    %w(name nick vat_number email created_at created_at active)
  end
end
