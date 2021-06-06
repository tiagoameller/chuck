class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]

  def index
    respond_to do |format|
      format.html { @question = Question.new }
      format.json { render json: QuestionsDatatable.new(view_context) }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show; end

  # POST /questions
  # POST /questions.json
  def create
    @question = make_question
    respond_to do |format|
      if @question.save
        format.js
      else
        format.js { render partial: 'toasts/errors', locals: { instance: @question } }
      end
    end
  end

  private

  def make_question
    Question.new.tap do |result|
      result.kind = question_params['kind']
      case result.kind.to_sym
      when :category
        result.question = question_params['category']
      when :word
        result.question = question_params['question']
      end
    end
  end

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
