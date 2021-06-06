class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :send_email]

  def index
    respond_to do |format|
      format.html { @question = Question.new }
      format.json { render json: QuestionsDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.js
      format.json { render json: AnswersDatatable.new(@question, view_context) }
    end
  end

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

  def send_email
    respond_to do |format|
      @email = question_params['email']
      if @email.blank?
        @question.errors.add(:email, I18n.t('question.email.error'))
        format.js { render partial: 'toasts/errors', locals: { instance: @question } }
      else
        format.js { UserMailer.answers(@question, @email).deliver_now }
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
      :question,
      :email
    )
  end
end
