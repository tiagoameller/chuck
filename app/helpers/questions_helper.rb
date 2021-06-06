module QuestionsHelper
  def render_question(model)
    [].tap do |column|
      present(model) do |question|
        column << link_to(
          question.kind_i18n,
          question_path(question),
          remote: true,
          data: {
            id: question.id
          }
        )
        column << question.question_for_display
        column << tag.div(
          question.created_at_in_words,
          data: {
            toggle: 'c-tooltip',
            placement: :top,
            title: question.created_at_formatted
          }
        )
        column << question.answer_count
        column << {
          row_id: dom_id(question)
        }
      end
    end
  end
end
