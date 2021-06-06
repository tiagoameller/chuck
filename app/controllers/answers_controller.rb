class AnswersController < ApplicationController
  before_action :set_question

  def index
    respond_to do |format|
      format.json { render json: AnswersDatatable.new(@question, view_context) }
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  rescue ActiveRecord::RecordNotFound
    toast_not_found
  end
end
