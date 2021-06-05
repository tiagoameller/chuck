# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  kind         :integer
#  question     :string
#  answer_count :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should define_enum_for(:kind) }

  describe 'full_name' do
    context 'by category' do
      it 'full_name contain category' do
        subject = Question.new attributes_for(:question_by_category)
        expect(subject.full_name).to eq I18n.t('question.by_category', category: subject.question)
      end
    end
    context 'by word' do
      it 'full_name contain word' do
        subject = Question.new attributes_for(:question_by_word)
        expect(subject.full_name).to eq I18n.t('question.by_word', word: subject.question)
      end
    end
    context 'by random' do
      it 'full_name is random' do
        subject = Question.new attributes_for(:question_by_random)
        expect(subject.full_name).to eq I18n.t('question.by_random')
      end
    end
  end
end
