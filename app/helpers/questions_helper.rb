module QuestionsHelper
  def render_question(model)
    [].tap do |column|
      present(model) do |question|
        column << link_to(
          question.created_at_in_words,
          question_path(question),
          remote: true,
          data: {
            id: question.id,
            toggle: 'c-tooltip',
            placement: :top,
            title: question.created_at_formatted
          }
        )
        column << question.kind_i18n
        column << question.question
        column << question.answer_count
        column << {
          row_id: dom_id(question)
        }
      end
    end
  end
end
