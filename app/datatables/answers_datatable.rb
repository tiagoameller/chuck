class AnswersDatatable < ApplicationDatatable
  SORT_COLUMNS = ['answers.value'].freeze
  SEARCH_COLUMNS = [
    'answers.value',
    'answers.categories'
  ].freeze

  def initialize(master, view)
    @question = master
    super(view)
  end

  private

  def sort_column
    SORT_COLUMNS[params.dig(:order, '0', :column).to_i]
  end

  def count
    @question.answers.count
  end

  def data
    answers.map { |model| @view.render_answer(model) }
  end

  def total_entries
    answers.total_count
  end

  def answers
    @answers ||= fetch_answers
  end

  def fetch_answers
    search_value = params[:search][:value] if params.key? :search
    answers =
      @question
      .answers
      .page(page)
      .per(per_page)
    if search_value.blank?
      answers
    else
      search_string = []
      SEARCH_COLUMNS.each { |term| search_string << "cast(#{term} as varchar) ilike :search" }
      answers.where(search_string.join(' or '), search: "%#{search_value}%")
    end
  end
end
