module ChuckNorrisApi
  extend ActiveSupport::Concern
  API_URL = 'https://api.chucknorris.io/jokes'.freeze

  module ClassMethods
    def new_from_params(question_params)
      Question.new.tap do |result|
        request_params = prepare_request(question_params)
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

    private

    def prepare_request(question_params)
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
  end

  # included do
  # end
end
