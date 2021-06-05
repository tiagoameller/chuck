class QuestionPresenter < ApplicationPresenter
  def created_at_in_words
    @view.time_ago_in_words(@model.created_at)
  end

  def created_at_formatted
    @view.format_date_time(@model.created_at)
  end
end
