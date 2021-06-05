module QuestionsHelper
  def render_question(model)
    [].tap do |column|
      present(model) do |question|
        column << link_to(time_ago_in_words(question.created_at), question_path(question), remote: true, data: { id: question.id })
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
