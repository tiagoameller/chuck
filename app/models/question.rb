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
class Question < ApplicationRecord
  include ChuckNorrisApi
  has_many :answers, dependent: :destroy

  enum kind: { category: 0, word: 1, random: 2 }

  def full_name
    case kind.to_sym
    when :category
      I18n.t('question.by_category', category: question)
    when :word
      I18n.t('question.by_word', word: question)
    else
      I18n.t('question.by_random')
    end
  end
end
