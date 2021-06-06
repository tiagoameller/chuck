class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]

  def index
    respond_to do |format|
      format.html { @question = Question.new }
      format.json { render json: QuestionsDatatable.new(view_context) }
    end
  end

  def show; end

  def create
    @question = Question.new_from_params(question_params)
    respond_to do |format|
      if @question.persisted?
        format.js
      else
        format.js { render partial: 'toasts/errors', locals: { instance: @question } }
      end
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    toast_not_found
  end

  def question_params
    params.require(:question).permit(
      :kind,
      :category,
      :question
    )
  end
end
