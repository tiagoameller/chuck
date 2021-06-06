module QuestionsHelper
  def render_question(model)
    [].tap do |row|
      present(model) do |question|
        row << link_to(
          question.kind_i18n,
          question_path(question),
          remote: true,
          data: {
            id: question.id
          }
        )
        row << question.question_for_display
        row << tag.div(
          question.created_at_in_words,
          data: {
            toggle: 'c-tooltip',
            placement: :top,
            title: question.created_at_formatted
          }
        )
        row << question.answer_count
        row << {
          row_id: dom_id(question)
        }
      end
    end
  end
end
