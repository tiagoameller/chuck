class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: QuestionsDatatable.new(view_context) }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show; end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    respond_to do |format|
      if @question.save
        # format.html { redirect_to question_path(@question), notice: I18n.t('controllers.created', model_name: Question.model_name.human) }
        format.js
      else
        # format.html { render :new }
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
      :question
    )
  end
end
