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
    @question = create_cuestion_from_api
    respond_to do |format|
      if @question.persisted?
        format.js
      else
        format.js { render partial: 'toasts/errors', locals: { instance: @question } }
      end
    end
  end

  private

  def create_cuestion_from_api
    Question.new.tap do |result|
      request_params = prepare_request
      response = HTTParty.get(request_params[:url], format: :plain)
      if response.code == 200
        result.kind = request_params[:kind]
        result.question = request_params[:question]
        answers = JSON.parse(response, symbolize_names: true)
        result.answer_count = answers[:total] || 1
        add_answers_to_question(result, answers[:result] || [answers]) if result.save
      else
        result.errors.add(:base, 'Something failed while retrieving your question')
      end
    end
  end

  def add_answers_to_question(question, answers)
    question.answers.create(
      [].tap do |result|
        answers.each do |answer|
          result << {
            categories: answer[:categories].join('|'),
            url: answer[:url],
            icon_url: answer[:icon_url],
            value: answer[:value]
          }
        end
      end
    )
  end

  def prepare_request
    {}.tap do |result|
      result[:kind] = question_params['kind']
      case result[:kind].to_sym
      when :category
        result[:question] = question_params['category']
        result[:url] = "#{API_URL}/random?category=#{result[:question]}"
      when :word
        result[:question] = question_params['question']
        result[:url] = "#{API_URL}/search?query=#{result[:question]}"
      when :random
        result[:question] = nil
        result[:url] = "#{API_URL}/random"
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
