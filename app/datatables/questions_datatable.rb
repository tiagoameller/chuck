class QuestionsDatatable < ApplicationDatatable
  SORT_COLUMNS = [
    'questions.created_at',
    'questions.kind',
    'questions.question',
    'questions.answer_count'
  ].freeze

  SEARCH_COLUMNS = [
    'questions.created_at',
    'questions.kind',
    'questions.question',
    'questions.answer_count'
  ].freeze

  private

  def sort_column
    SORT_COLUMNS[params.dig(:order, '0', :column).to_i]
  end

  def count
    Question.count
  end

  def data
    questions.map { |model| @view.render_question(model) }
  end

  def total_entries
    questions.count
  end

  def questions
    @questions ||= fetch_questions
  end

  def fetch_questions
    search_value = params[:search][:value] if params.key? :search
    questions =
      Question
      .page(page)
      .per(per_page)
      .order("#{sort_column} #{sort_direction}")
    if search_value.blank?
      questions
    else
      search_string = []
      SEARCH_COLUMNS.each { |term| search_string << "cast(#{term} as varchar) ilike :search" }
      Question.where(search_string.join(' or '), search: "%#{search_value}%")
    end
  end
end
